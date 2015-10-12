import os
import sys
import json
import jsonschema
import collections
from .errors import *
from .helpers import *

class TPXObject(object):
  """base class containing methods to be implemented"""

  _path = None
  _file = None
  _data = None

  def __init__(self, filepath):
    try:
      self._file = open(filepath, 'rb')
      self._path = os.path.dirname(filepath)
      self._data = self._file.read()
      if type(self._data) is bytes: self._data = self._data.decode('utf-8')
      self._data = json.loads(self._data, object_pairs_hook=collections.OrderedDict)
    except Exception as e:
      if type(e) == IOError:
        raise ValidationError('TPX file provided is invalid. Error while opening file ' + filepath + ': "' + str(e) + '"')
      if type(e) == ValueError:
          error_message = str(e)
          if error_message == "No JSON object could be decoded":
              error_message = "TPX has no content. " + error_message
          raise ValidationError('TPX file provided is invalid. Error while parsing file ' + filepath + ': "' + error_message + '". Perhaps you should use JSONLint (jsonlint.org) to validate that you are using correct JSON syntax.')
      else:
        raise ValidationError('TPX file provided is invalid. Error processing file ' + filepath + ': "' + str(e) + '"')

  @property
  def keys(self):
    return list(self._data.keys())

  def validate(self, schema):
    return NotImplementedError

  def validate_schema(self, schema):
    validator = jsonschema.Draft4Validator(schema, format_checker=jsonschema.FormatChecker())
    schema_validation_errors = sorted(validator.iter_errors(self._data), key=lambda e: e.path)

    if len(schema_validation_errors) > 0:
      raise ValidationError('Error(s) in schema validation (' + self._file.name + '):\n' + errors_to_string(schema_validation_errors))

class Exchange(TPXObject):
  """TPX file, either a manifest or single-file"""

  def validate(self, schema, quiet=False):
    manifest_required_fields  = ['dictionary_file_manifest',
                                 'observable_element_file_manifest',
                                 'collection_file_manifest',
                                 'network_file_manifest']

    single_required_fields    = ['observable_dictionary_c_array',
                                 'element_observable_c_array',
                                 'collection_c_array',
                                 'asn_c_array']

    single_keys   = set(single_required_fields) & set(self.keys)
    manifest_keys = set(manifest_required_fields) & set(self.keys)

    # if we determine the file to be a manifest
    if len(single_keys) == 0 and len(manifest_keys) > 0:
      # validate the manifest against the schema
      self.validate_schema(schema)

      for field in manifest_required_fields:
        if field in self.keys:
          for referenced_file in self._data[field]:
            referenced_json = TPXObject(os.path.join(self._path, referenced_file))

            if field == 'dictionary_file_manifest': element_type = 'observable'
            if field == 'observable_element_file_manifest': element_type = 'element_observable'
            if field == 'collection_file_manifest': element_type = 'collection'
            if field == 'network_file_manifest': element_type = 'network'

            element_schema = {
              '$schema': 'http://json-schema.org/draft-04/schema#',
              'definitions': schema['definitions'],
              'properties': {
                single_required_fields[manifest_required_fields.index(field)]: {
                  'type': 'array',
                  'minItems': 1,
                  'items': {
                    '$ref': '#/definitions/' + element_type
                  }
                }
              },
              'required': [single_required_fields[manifest_required_fields.index(field)]]
            }
            referenced_json.validate_schema(element_schema)

    # if we determine the file to be a single file
    elif len(manifest_keys) == 0 and len(single_keys) > 0:
      # validate the manifest against the schema
      self.validate_schema(schema)

      try:
        observable_ids = [o['observable_id_s'] for o in self._data.get('observable_dictionary_c_array', [])]
        if not observable_ids:
          print('Warning: observable_dictionary_c_array is empty or not defined')
        for element_observable in self._data.get('element_observable_c_array', []):
          for referenced_observable in element_observable['threat_observable_c_map']:
            if not referenced_observable in observable_ids:
                if not quiet:
                  if observable_ids:
                    print('Warning: Observable ' + referenced_observable + ' is not defined in the observable dictionary.')
      except KeyError as e:
        try:
          raise ValidationError('Element observable without threat_observable_c_map: ' + json.dumps(element_observable))
        except NameError:
          pass

    # some mix of single file and manifest keys
    elif len(single_keys) > 0 and len(manifest_keys) > 0:
      raise ValidationError('TPX file must either be in single-file or manifest format.')

    else:
      self.validate_schema(schema)

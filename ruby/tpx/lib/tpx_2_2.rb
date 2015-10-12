module TPX_2_2
  CURRENT_SCHEMA_VERSION = '2.2.0'
  SCHEMA = File.join(File.dirname(File.expand_path(__FILE__)), 'tpx', '2_2', 'schema', 'tpx.2.2.schema.json')

  require 'json-schema'
  require 'active_support'
  require 'active_support/core_ext/object/blank'
  require 'active_support/core_ext/hash'
  require 'oj'

  require 'tpx/2_2/exceptions'
  require 'tpx/2_2/validator'
  require 'tpx/2_2/exchange'
end

import os
import json

schema_dir = os.path.join(os.path.dirname(__file__), '../../../', 'schema')
schema_json = json.loads(open(os.path.join(schema_dir, 'tpx.2.2.schema.json')).read())

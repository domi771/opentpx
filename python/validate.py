from tpxvalidate import TPX_2_1
from tpxvalidate import TPX_2_2

import click
import json
import os


@click.command()
@click.argument('tpx_file', type=str, required=True)
@click.option('--version', '-v', default="2.2", help="TPX version to use.")
@click.option('--schema', '-s', type=click.Path(), help="Path to external schema file.")
@click.option('--quiet', '-q', is_flag=True, default=False, help="Quiet warnings and non-essential messages.")
def validate(tpx_file, version, schema, quiet):
    try:
        if schema:
            schema_file = open(os.path.join(os.path.dirname(__file__), schema), 'rb')
            schema_json = json.loads(schema_file.read().decode())

        if version == '2.1':
            TPXExchange = TPX_2_1.Exchange(tpx_file)
            if not schema: schema_json = TPX_2_1.schema_json

        elif version == '2.2':
            TPXExchange = TPX_2_2.Exchange(tpx_file)
            if not schema: schema_json = TPX_2_2.schema_json
        else:
            raise TPX_2_2.ValidationError('Unknown TPX Version: ' + version)


        TPXExchange.validate(schema_json, quiet)
        print('Validation succeeded against TPX ' + version)
    except Exception as e:
          print(str(e))

if __name__ == '__main__': validate()

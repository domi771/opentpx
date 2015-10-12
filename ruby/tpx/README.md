# OpenTPX - Threat Partner eXchange

OpenTPX is an open-source format and tools for exchanging machine-readable threat intelligence and network security operations data.  This is a JSON-based format that allows sharing of data between connected systems.

This is the open source Ruby gem developed by Lookingglass Cyber Solutions.

## Installation

### Gem

You must use an installed gem to use the validator and parser tools.

    gem install open_tpx

To validate a file in your own scripts:

    require 'open_tpx'
    TPX_2_2::Validator.validate_file! "path/to/my/tpx.json"

Or use the `opentpx_tools` executable:

    opentpx_tools validate 'path/to/my/tpx.json'

Options allow you to quiet warnings and specify the tpx version. By default, it will verify for the latest TPX version. For more help:

    opentpx_tools help validate



--------------------------------------------------------------------------------------------------------------------------------
Copyright 2015 LookingGlass Cyber Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.

--------------------------------------------------------------------------------------------------------------------------------

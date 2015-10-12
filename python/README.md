# OpenTPX - Threat Partner eXchange

OpenTPX is an open-source format and tools for exchanging machine-readable threat intelligence and network security operations data.  This is a JSON-based format that allows sharing of data between connected systems.

This is the open source Python package for TPX verification developed by Lookingglass Cyber Solutions.

## Installation
After cloning the repository, create a [virtualenv](https://virtualenv.pypa.io/en/latest/).  If you do not have virtualenv installed, then follow [these instructions](https://virtualenv.pypa.io/en/latest/installation.html) to install it.  Select the latest version of virtualenv so that pip is included.

Next, install the dependencies for the package by moving to the python/ directory and running:

    virtualenv -p python2.7 env/
    source env/bin/activate
    pip install -r requirements.txt

Then the module can be imported into any python script with:

    import tpxvalidate

The validation script is designed to run on both Python 2 and 3.

## Usage
A basic script using the tpxvalidate package, ```validate.py``` is included. By default (if no version parameter is specified) it will verify for the latest TPX version.

    Usage: python validate.py [OPTIONS] TPX_FILE

    Options:
      -v, --version [2.1|2.2]  TPX version to use.
      -s, --schema PATH        Path to external schema file.
      --help                   Show this message and exit.

--------------------------------------------------------------------------------------------------------------------------------
Copyright 2015 LookingGlass Cyber Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

--------------------------------------------------------------------------------------------------------------------------------

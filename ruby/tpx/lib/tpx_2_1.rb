module TPX_2_1
  CURRENT_SCHEMA_VERSION = '2.1.6'
  SCHEMA = File.join(File.dirname(File.expand_path(__FILE__)), 'tpx', '2_1', 'schema', 'tpx.2.1.schema.json')

  require 'json-schema'
  require 'active_support'
  require 'active_support/core_ext/object/blank'
  require 'active_support/core_ext/hash'
  require 'oj'

  require 'tpx/2_1/exceptions'
  require 'tpx/2_1/validator'
  require 'tpx/2_1/exchange'
end

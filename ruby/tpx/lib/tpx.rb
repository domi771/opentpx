$LOAD_PATH << __dir__ unless $LOAD_PATH.include?(__dir__)

module TPX
  require 'tpx/version'
  # load the current TPX version
  # todo: docs here on how to interface with non-current versions
  require 'tpx_2_2'
  require 'tpx_2_1'
end

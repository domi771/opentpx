require 'gli'
require 'tpx'

module TPX
  class Tools
    extend ::GLI::App

    TPX_VALID = "Validation succeeded"
    TPX_INVALID = "The TPX file provided is invalid for the following reasons:"
    TPX_VERSION_UNKNOWN = "Unknown TPX Version: "

    class << self
      attr_accessor :quiet

      def msg(message)
        puts message unless quiet
      end

      def get_tpx_version_const(tpx_version)
        underscored_tpx_version = tpx_version.gsub('.', '_')
        Object.const_get("TPX_#{underscored_tpx_version}")
      rescue NameError => e
        msg( e )
        raise TPX_VERSION_UNKNOWN + "'#{tpx_version}'"
      end

      def validate(tpx_version_const, filepath)
        begin
          tpx_version_const::Validator.validate_file! filepath
        rescue tpx_version_const::ValidationWarning => w
          msg( "Warning: #{w}" )
          puts TPX_VALID + " against " + tpx_version_const.to_s
        rescue => e
          puts TPX_INVALID
          puts e
        else
          puts TPX_VALID
        end
      end


    end

    program_desc 'OpenTPX Tools'
    version TPX::VERSION

    switch [:q, :quiet], default_value: false,
                           desc: 'quiet non-essential output and warnings.'

    #--- COMMAND validate
    desc "validates that a file is of a valid TPX file format"
    long_desc "validates that a file is of a valid TPX file format\n\n" \
      "TPX_FILE_PATH - The path to the TPX file. The file may be either a" \
      " stand-alone TPX file or a tpx manifest file. For details on TPX" \
      " manifest, please see https://github.com/Lookingglass/tpx"

    arg 'TPX_FILE_PATH'

    command :validate do |c|
      c.flag [:v, :tpx_version], default_value: "2.2",
        arg_name: 'VERSION',
        type: String,
        desc: "The version of tpx to validate the file against. Possible" \
        " values: '2.1', '2.2'"

      c.action do |global_options, options, args|
        self.quiet = global_options[:quiet]
        tpx_version = options[:tpx_version]
        tpx_file_path = args[0]

        raise "Missing option TPX_VERSION" if tpx_version.nil?
        raise "Missing arg TPX_FILE_PATH" if tpx_file_path.nil?

        tpx_version = tpx_version.strip
        msg( "Validating '#{tpx_file_path}' against TPX '#{tpx_version}' schema" )
        tpx_version_const = get_tpx_version_const(tpx_version)
        validate(tpx_version_const, tpx_file_path)
      end
    end
  end
end

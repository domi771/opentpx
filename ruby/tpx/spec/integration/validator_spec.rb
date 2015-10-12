require 'rspec'
require 'tpx/tools'
require 'tempfile'
require 'open3'

require 'shared_examples/shared_examples_for_validator'

describe 'validator integration' do

  context 'using the python validator tool' do
    it_behaves_like "a validator" do
      let(:bin_path){ File.expand_path(File.join( __FILE__ , '..', '..', '..', '..', '..', 'python')) }
      let(:command_path){ File.join( bin_path, 'validate.py') }
      let(:command) { "python #{command_path} #{version} #{quiet} #{args} 2>&1" }
    end
  end

  context 'using ruby validator tool' do
    it_behaves_like "a validator" do
      let(:bin_path){ File.expand_path(File.join( __FILE__ , '..', '..', '..', 'bin')) }
      let(:global_options){ "#{quiet}" }
      let(:command_path){ File.join( bin_path, 'opentpx_tools') }
      let(:command) { "ruby #{command_path} #{global_options} validate #{version} #{args} 2>&1" }
    end
  end
end


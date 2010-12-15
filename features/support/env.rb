require 'aruba'
# This should only be called if the gem is vendored, otherwise it will probably attempt to write to your
# root directory!!!
 Before do
    @dirs = [File.expand_path(File.dirname(__FILE__) + '/../../../../../../aruba_test_dir')]
 end

=begin
#$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
#require 'aruba/cucumber'
require 'fileutils'

begin
  # rspec-2
  require 'rspec/expectations'
rescue LoadError
  # rspec-1
  require 'spec/expectations'
end

Before do
  FileUtils.rm(Dir['config/*.yml'])
end
=end
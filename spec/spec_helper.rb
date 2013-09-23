require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fileutils'
require 'tmpdir'
require 'vvm-rb'
require 'vvm-rb/constants'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before :all do
    clear_consts
    @cache = File.expand_path(File.join(File.dirname(__FILE__), '..', '.vvm_cache'))
    DOT_DIR = @cache
    unless Dir.exists?(@cache)
      FileUtils.mkdir_p(@cache)
      Cli.start('install v7-3-969'.split)
      Cli.start('install v7-4'.split)
    end
  end

  config.before :each do
    clear_consts
    @tmp = Dir.mktmpdir
    FileUtils.cp_r(@cache, @tmp)
    DOT_DIR = File.expand_path(File.join(@tmp, '.vvm_cache'))
    p @tmp
  end

  config.after :each do
    # FileUtils.rm_rf(@tmp)
  end
end

def clear_consts
  %w{ DOT_DIR }.each do |c|
    const = c.to_sym
    Object.send(:remove_const, const) if Object.const_defined?(const)
  end
end

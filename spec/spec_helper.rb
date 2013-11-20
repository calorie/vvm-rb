require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fileutils'
require 'tmpdir'
require 'vvm-rb'
include VvmRb

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.before :suite do
    cache_dir = get_cache_dir
    unless File.exists?(cache_dir)
      ENV['VVMROOT'] = cache_dir
      FileUtils.mkdir_p(cache_dir)
      Installer.fetch
      %w{ v7-3-969 v7-4 }.each do |v|
        i = Installer.new(v)
        i.checkout
        i.configure
        i.make_install
      end
      Installer.cp_etc
    end
  end

  config.before :all do
    @tmp = Dir.mktmpdir
    FileUtils.cp_r(get_cache_dir, @tmp)
    ENV['VVMROOT'] = File.expand_path(File.join(@tmp, '.vvm_cache'))
    ENV['VVMOPT'] = nil
  end

  config.after :all do
    FileUtils.rm_rf(@tmp)
  end
end

def get_cache_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..', '.vvm_cache'))
end

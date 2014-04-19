require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fileutils'
require 'tmpdir'
require 'vvm-rb'
include VvmRb

support = File.join(File.dirname(__FILE__), 'support', '**', '*.rb')
Dir[support].each { |f| require f }

VERSION1, VERSION2 = 'v7-4-083', 'v7-4-103'

# [todo] - test is too slow

RSpec.configure do |config|
  config.before :suite do
    cache_dir = get_cache_dir
    unless File.exist?(cache_dir)
      ENV['VVMROOT'] = cache_dir
      FileUtils.mkdir_p(cache_dir)
      Installer.fetch
      [VERSION1, VERSION2].each do |v|
        i = Installer.new(v, [], true)
        i.checkout
        i.configure
        i.make_install
      end
      Installer.cp_etc
    end
  end

  config.before :all do
    @tmp = Dir.mktmpdir
    unless self.class.metadata[:disable_cache]
      FileUtils.cp_r(get_cache_dir, @tmp)
    end
    ENV['VVMROOT'] = File.expand_path(File.join(@tmp, '.vvm_cache'))
    ENV['VVMOPT']  = nil
  end

  config.after :all do
    FileUtils.rm_rf(@tmp)
  end

  config.before(:all, clean: true) { remove_directories }
  config.before(:all, vimorg: true) { cp_vimorg_dir }
  config.before(:all, src: true) { cp_src_dir }
end

def get_cache_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..', '.vvm_cache'))
end

def remove_directories
  [get_src_dir, get_vims_dir, get_vims_dir, get_etc_dir].each do |dir|
    FileUtils.rm_rf(dir) if File.exist?(dir)
  end
end

def cp_vimorg_dir
  return if File.exist?(get_vimorg_dir)
  FileUtils.mkdir_p(get_repos_dir)
  FileUtils.cp_r(File.join(get_cache_dir, 'repos', 'vimorg'), get_repos_dir)
end

def cp_src_dir
  return if File.exist?(get_src_dir(@version))
  FileUtils.mkdir_p(get_src_dir)
  FileUtils.cp_r(File.join(get_cache_dir, 'src', @version), get_src_dir)
end

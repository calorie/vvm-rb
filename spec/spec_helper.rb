require 'simplecov'
require 'coveralls'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/vendor/'
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fileutils'
require 'tmpdir'
require 'vvm'

VERSION1 = 'v7.4.083'.freeze
VERSION2 = 'v7.4.103'.freeze

# [todo] - test is too slow

RSpec.configure do |config|
  config.before :suite do
    cache = cache_dir
    unless File.exist?(cache)
      ENV['VVMROOT'] = cache
      ENV['VVMOPT']  = nil
      FileUtils.mkdir_p(cache)
      Vvm::Installer.fetch
      [VERSION1, VERSION2].each do |v|
        i = Vvm::Installer.new(v, [], true)
        i.checkout
        i.configure
        i.make_install
      end
      Vvm::Installer.cp_etc
    end
  end

  config.before :all do
    @tmp = Dir.mktmpdir
    FileUtils.cp_r(cache_dir, @tmp) unless self.class.metadata[:disable_cache]
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

def cache_dir
  File.expand_path(File.join(File.dirname(__FILE__), '..', '.vvm_cache'))
end

def remove_directories
  [src_dir, vimorg_dir, vims_dir, etc_dir].each do |dir|
    FileUtils.rm_rf(dir) if File.exist?(dir)
  end
end

def cp_vimorg_dir
  return if File.exist?(vimorg_dir)
  FileUtils.mkdir_p(repos_dir)
  FileUtils.cp_r(File.join(cache_dir, 'repos', 'vimorg'), repos_dir)
end

def cp_src_dir
  return if File.exist?(src_dir(@version))
  FileUtils.mkdir_p(src_dir)
  FileUtils.cp_r(File.join(cache_dir, 'src', @version), src_dir)
end

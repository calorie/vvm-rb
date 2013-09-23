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

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.before :suite do
    clear_consts
    CACHE_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '.vvm_cache'))
    DOT_DIR   = CACHE_DIR
    ETC_DIR   = "#{DOT_DIR}/etc"
    REPOS_DIR = "#{DOT_DIR}/repos"
    SRC_DIR   = "#{DOT_DIR}/src"
    VIMS_DIR  = "#{DOT_DIR}/vims"
    VIM_URI   = 'https://vim.googlecode.com/hg/'
    unless Dir.exists?(CACHE_DIR)
      FileUtils.mkdir_p(CACHE_DIR)
      Cli.start('install v7-3-969'.split)
      Cli.start('install v7-4'.split)
    end
  end

  config.before :all do
    clear_consts
    @tmp = Dir.mktmpdir
    FileUtils.cp_r(CACHE_DIR, @tmp)
    DOT_DIR   = File.expand_path(File.join(@tmp, '.vvm_cache'))
    ETC_DIR   = "#{DOT_DIR}/etc"
    REPOS_DIR = "#{DOT_DIR}/repos"
    SRC_DIR   = "#{DOT_DIR}/src"
    VIMS_DIR  = "#{DOT_DIR}/vims"
  end

  config.after :all do
    FileUtils.rm_rf(@tmp)
  end
end

def clear_consts
  %w{
    DOT_DIR
    ETC_DIR
    REPOS_DIR
    SRC_DIR
    VIMS_DIR
  }.each do |c|
    const = c.to_sym
    Object.send(:remove_const, const) if Object.const_defined?(const)
  end
end

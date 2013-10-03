require 'thor'
require 'vvm-rb/validator'
require 'vvm-rb/installer'
require 'vvm-rb/uninstaller'
require 'vvm-rb/switcher'

class Cli < Thor
  include Thor::Actions
  include Validator

  desc 'install [TAG] [options]', 'Install a specific version of Vim'
  def install(version, *conf)
    installer = Installer.new(version, conf)
    installer.install
  end

  desc 'reinstall [TAG] [options]', 'Reinstall a specific version of Vim'
  def reinstall(version, *conf)
    uninstaller = Uninstaller.new(version)
    uninstaller.uninstall
    installer = Installer.new(version, conf)
    installer.install
  end

  desc 'rebuild [TAG] [options]', 'Rebuild a specific version of Vim, then install it'
  def rebuild(version, *conf)
    installer = Installer.new(version, conf)
    installer.rebuild
  end

  desc 'use [TAG]', 'Use a specific version of Vim as the default one.'
  def use(version)
    switcher = Switcher.new(version)
    switcher.use
  end

  desc 'list', 'Look available vim versions'
  def list
    Installer.fetch
    Dir.chdir(VIMORG_DIR) do
      list = `hg tags`.split.reverse
      puts list.values_at(* list.each_index.select {|i| i.odd?}).join("\n")
    end
  end

  desc 'versions', 'Look installed vim versions.'
  def versions
    Dir.glob("#{VIMS_DIR}/v*").sort.each{ |d| puts File.basename(d) }
  end

  desc 'uninstall [TAG]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    uninstaller = Uninstaller.new(version)
    uninstaller.uninstall
  end

  before(:install, :reinstall, :rebuild, :list) { validations }
end

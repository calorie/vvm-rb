require 'thor'

class Cli < Thor
  include Thor::Actions
  include VvmRb::Base

  desc 'install [TAG] [options]', 'Install a specific version of Vim'
  method_option :use, :type => :boolean, :aliases => '-u'
  def install(version, *conf)
    installer(version, conf)
    use(version) if options[:use]

    print "\e[32m"
    puts <<-EOS

Vim is successfully installed.  For daily use,
please add the following line into your ~/.bash_login etc:

test -f ~/.vvm-rb/etc/login && source ~/.vvm-rb/etc/login

    EOS
    print "\e[0m"
  end

  desc 'reinstall [TAG] [options]', 'Reinstall a specific version of Vim'
  def reinstall(version, *conf)
    Uninstaller.new(version).uninstall
    installer(version, conf)
  end

  desc 'rebuild [TAG] [options]', 'Rebuild a specific version of Vim'
  def rebuild(version, *conf)
    rebuilder(version, conf)
  end

  desc 'use [TAG]', 'Use a specific version of Vim as the default one.'
  def use(version)
    Switcher.new(version).use
  end

  desc 'list', 'Look available vim versions'
  def list
    Installer.fetch
    puts Version.list.join("\n")
  end

  desc 'versions', 'Look installed vim versions.'
  def versions
    puts Version.versions.join("\n")
  end

  desc 'uninstall [TAG]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    Uninstaller.new(version).uninstall
  end

  before_method(:install, :reinstall, :rebuild, :list) { check_hg }
  before_method(:install, :reinstall, :rebuild, :use, :uninstall) { check_tag }
  before_method(:install) { new_version? }
  before_method(:reinstall, :rebuild, :use, :uninstall) { version_exist? }

  private

  def installer(version, conf)
    Installer.fetch
    if version == 'latest'
      version = Version.list.select { |v| v =~ /^v7-.+$/ }.last
      new_version?(version)
    end
    i = Installer.new(version, conf)
    i.checkout
    i.configure
    i.make_install
    Installer.cp_etc
  end

  def rebuilder(version, conf)
    r = Installer.new(version, conf)
    r.make_clean
    r.configure
    r.make_install
  end
end

require 'thor'

class Cli < Thor
  include Thor::Actions
  include Validator

  desc 'install [TAG] [options]', 'Install a specific version of Vim'
  def install(version, *conf)
    installer(version, conf)

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

  desc 'rebuild [TAG] [options]', 'Rebuild a specific version of Vim, then install it'
  def rebuild(version, *conf)
    rebuilder(version, conf)
  end

  desc 'use [TAG]', 'Use a specific version of Vim as the default one.'
  def use(version)
    Switcher.new(version).use
  end

  desc 'list', 'Look available vim versions'
  def list
    Installer.new('dummy').fetch
    puts Version.new.list
  end

  desc 'versions', 'Look installed vim versions.'
  def versions
    puts Version.new.versions
  end

  desc 'uninstall [TAG]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    Uninstaller.new(version).uninstall
  end

  before_method(:install, :reinstall, :rebuild, :list) { check_hg }
  before_method(:install, :reinstall, :rebuild, :use, :uninstall) { check_tag }

  private

  def installer(version, conf)
    i = Installer.new(version, conf)
    i.fetch
    i.checkout
    i.configure
    i.make_install
    i.cp_etc
  end

  def rebuilder(version, conf)
    r = Installer.new(version, conf)
    r.make_clean
    r.configure
    r.make_install
  end
end

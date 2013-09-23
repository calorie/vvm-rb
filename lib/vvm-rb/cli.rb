require 'thor'
require 'vvm-rb/validator'
require 'vvm-rb/installer'
require 'vvm-rb/uninstaller'
require 'vvm-rb/switcher'

class Cli < Thor
  include Thor::Actions

  desc 'install [TAG] [options]', 'Install a specific version of Vim'
  def install(version, *conf)
    installer = Installer.new(version, conf)
    installer.install
    print "\e[32m"
    puts <<-EOS

Vim is successfully installed.  For daily use,
please add the following line into your ~/.bash_login etc:

test -f ~/.vvm-rb/etc/login && source ~/.vvm-rb/etc/login

    EOS
    print "\e[0m"
  end

  desc 'use [TAG]', 'Use a specific version of Vim as the default one.'
  def use(version)
    switcher = Switcher.new(version)
    switcher.use
  end

  desc 'uninstall [TAG]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    uninstaller = Uninstaller.new(version)
    uninstaller.uninstall
  end
end

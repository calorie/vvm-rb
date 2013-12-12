require 'thor'

class Cli < Thor
  include Thor::Actions
  include VvmRb::Base

  desc 'install [VERSION] [CONFIGURE_OPTS]', 'Install a specific version of Vim'
  method_option :use, type: :boolean, aliases: '-u', banner: 'Use installed vim'
  def install(version, *conf)
    i = Installer.new(Version.format(version), conf)
    i.checkout
    i.configure
    i.make_install
    Installer.cp_etc

    use(version) if options[:use]

    message
  end

  desc 'reinstall [VERSION] [CONFIGURE_OPTS]', 'Reinstall a specific version'
  def reinstall(version, *conf)
    uninstall(version)
    install(version, conf)
  end

  desc 'rebuild [VERSION] [CONFIGURE_OPTS]', 'Rebuild a specific version of Vim'
  def rebuild(version, *conf)
    r = Installer.new(Version.format(version), conf)
    r.make_clean
    r.configure
    r.make_install
  end

  desc 'use [VERSION]', 'Use a specific version of Vim as the default one.'
  def use(version)
    Switcher.new(Version.format(version)).use
  end

  desc 'list', 'Look available vim versions'
  def list
    puts Version.list.join("\n")
  end

  desc 'versions', 'Look installed vim versions.'
  def versions
    puts Version.versions.join("\n")
  end

  desc 'uninstall [VERSION]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    Uninstaller.new(Version.format(version)).uninstall
  end

  before_method(:install) { new_version? }
  before_method(:reinstall, :rebuild, :use, :uninstall) { version_exist? }
  before_method(:install, :reinstall, :rebuild, :use, :uninstall) { check_tag }
  before_method(:install, :list) { Installer.pull }
  before_method(:install, :reinstall, :rebuild, :list) { check_hg }
  before_method(*instance_methods(false)) do
    Installer.fetch unless File.exists?(get_vimorg_dir)
  end

  private

  def message
    print "\e[32m"
    puts <<-EOS

Vim is successfully installed.  For daily use,
please add the following line into your ~/.bash_login etc:

test -f ~/.vvm-rb/etc/login && source ~/.vvm-rb/etc/login

    EOS
    print "\e[0m"
  end
end

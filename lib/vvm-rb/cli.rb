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

    invoke :use, [version], {} if options[:use]

    message if $?.success?
  end

  desc 'update', 'Update to latest version of Vim'
  def update
    current = Version.current
    if current == 'system'
      run 'vvm-rb install --use latest'
      run 'vvm-rb use system' unless $?.success?
    else
      run 'vvm-rb use system'
      run 'vvm-rb install --use latest'
      action = $?.success? ? 'uninstall' : 'use'
      run "vvm-rb #{action} #{current}"
    end
  end

  desc 'reinstall [VERSION] [CONFIGURE_OPTS]', 'Reinstall a specific version'
  def reinstall(version, *conf)
    invoke :uninstall, [version]
    invoke :install, [version, *conf]
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

  desc 'list', 'Look available versions of Vim.'
  def list
    puts Version.list.join("\n")
  end

  desc 'versions', 'Look installed versions of Vim.'
  def versions
    puts Version.versions.join("\n")
  end

  desc 'uninstall [VERSION]', 'Uninstall a specific version of Vim.'
  def uninstall(version)
    Uninstaller.new(Version.format(version)).uninstall
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

  def self.init_vvm_rb
    before_method(*instance_methods(false)) do
      Installer.fetch unless File.exists?(get_vimorg_dir)
    end
  end

  def self.validations
    before_method(:install) { new_version? }
    before_method(:reinstall, :rebuild, :use, :uninstall) { has_version? }
    before_method(:install, :reinstall, :rebuild, :use, :uninstall) { version? }
    before_method(:install, :list) { Installer.pull }
    before_method(:install, :reinstall, :rebuild, :list) { has_hg? }
  end

  validations

  init_vvm_rb
end

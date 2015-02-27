require 'thor'

module Vvm
  class Cli < Thor
    include Thor::Actions
    include Validator

    desc 'install [VERSION] [CONFIGURE_OPTS]', 'Install a specific version of Vim'
    method_option :use, type: :boolean, aliases: '-u', banner: 'Use installed vim'
    def install(version, *conf)
      i = Installer.new(Version.format(version), conf)
      i.checkout
      i.configure
      i.make_install
      Installer.cp_etc
      invoke :use, [version], {} if options[:use]
      i.message
    end

    desc 'update', 'Update to latest version of Vim'
    def update
      Installer.pull
      if (current = Version.current) == 'system'
        run 'vvm install --use latest'
        run 'vvm use system' unless $?.success?
      else
        run 'vvm use system'
        run 'vvm install --use latest'
        action = $?.success? ? 'uninstall' : 'use'
        run "vvm #{action} #{current}"
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
      Installer.pull
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

    no_commands do
      def invoke_command(command, *args)
        validate_before_invoke(command.name)
        super
      end
    end
  end
end

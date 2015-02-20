require 'mkmf'

module Vvm
  module Validator
    module_function

    def validate_before_invoke(command)
      new_version? if command == 'install'
      has_version? if %w(reinstall rebuild use uninstall).include?(command)
      version? if %w(install reinstall rebuild use uninstall).include?(command)
      has_hg? if %w(install reinstall rebuild list).include?(command)
    end

    def has_hg?
      unless Kernel.find_executable('hg')
        abort 'mercurial is required to install.'
      end
      return true
    end

    def version?
      if get_version.nil?
        abort 'undefined vim version. please run [ vvm-rb list ].'
      end
      return true
    end

    def new_version?(version = get_version)
      abort "#{version} is already installed." if version_include?(version)
      return true
    end

    def has_version?(version = get_version)
      abort "#{version} is not installed." unless version_include?(version)
      return true
    end

    private

    def get_version
      version_regex = /\Av7-.+\z|\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
      regex = /(\Astart\z|\Atip\z|\Asystem\z|\Alatest\z|#{version_regex})/
      version = $*.find { |v| v =~ regex }
      return Version.format(version)
    end

    def version_include?(version)
      return Version.versions.include?(version) || use_system?(version)
    end

    def use_system?(version)
      return version == 'system' && $*.include?('use')
    end
  end
end

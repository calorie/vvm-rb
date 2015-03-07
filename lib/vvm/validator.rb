require 'mkmf'

module Vvm
  module Validator
    METHOD_MAP = {
      install:   %w(version? hg? new_version?),
      update:    %w(hg?),
      reinstall: %w(hg? installed_version?),
      rebuild:   %w(version? hg? installed_version?),
      use:       %w(version? installed_version?),
      list:      %w(hg?),
      uninstall: %w(version? installed_version?)
    }

    module_function

    def validate_before_invoke(command)
      return unless validations = METHOD_MAP[command.to_sym]
      validations.each { |m| send(m) }
    end

    def hg?
      abort 'mercurial is required to install.' unless find_executable('hg')
      true
    end

    def version?
      abort 'undefined vim version. please run [ vvm list ].' if find_version.nil?
      true
    end

    def new_version?(ver = nil)
      Installer.pull
      ver = version if ver.nil?
      abort "#{ver} is already installed." if version_include?(ver)
      true
    end

    def installed_version?(ver = version)
      abort "#{ver} is not installed." unless version_include?(ver)
      true
    end

    private

    def find_version
      version_regex = /\Av7-.+\z|\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
      regex = /(\Astart\z|\Atip\z|\Asystem\z|\Alatest\z|#{version_regex})/
      $*.find { |v| v =~ regex }
    end

    def version
      Version.format(find_version)
    end

    def version_include?(ver)
      Version.versions.include?(ver) || use_system?(ver)
    end

    def use_system?(ver)
      ver == 'system' && $*.include?('use')
    end
  end
end

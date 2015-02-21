require 'mkmf'

module Vvm
  module Validator
    module_function

    def validate_before_invoke(command)
      new_version? if command == 'install'
      installed_version? if %w(reinstall rebuild use uninstall).include?(command)
      version? if %w(install rebuild use uninstall).include?(command)
      hg? if %w(install reinstall rebuild list).include?(command)
    end

    def hg?
      abort 'mercurial is required to install.' unless find_executable('hg')
      true
    end

    def version?
      abort 'undefined vim version. please run [ vvm list ].' if version.nil?
      true
    end

    def new_version?(ver = version)
      abort "#{ver} is already installed." if version_include?(ver)
      true
    end

    def installed_version?(ver = version)
      abort "#{ver} is not installed." unless version_include?(ver)
      true
    end

    private

    def version
      version_regex = /\Av7-.+\z|\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
      regex = /(\Astart\z|\Atip\z|\Asystem\z|\Alatest\z|#{version_regex})/
      ver = $*.find { |v| v =~ regex }
      Version.format(ver)
    end

    def version_include?(ver)
      Version.versions.include?(ver) || use_system?(ver)
    end

    def use_system?(ver)
      ver == 'system' && $*.include?('use')
    end
  end
end

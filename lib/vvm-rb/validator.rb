module Validator
  module_function

  def check_hg
    unless Kernel.system('which hg > /dev/null')
      abort 'mercurial is required to install.'
    end
    return true
  end

  def check_tag
    if get_version.nil?
      abort 'undefined vim version. please run [ vvm-rb list ].'
    end
    return true
  end

  def new_version?(version = get_version)
    abort "#{version} is already installed." if version_include?(version)
    return true
  end

  def version_exist?(version = get_version)
    abort "#{version} is not installed." unless version_include?(version)
    return true
  end

  private

  def get_version
    regex = /(^start$|^tip$|^v7-.+$|^(\d\.\d\.\d+)$|^system$|^latest$)/
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

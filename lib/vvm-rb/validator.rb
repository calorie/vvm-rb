module Validator
  module_function

  def check_hg
    unless Kernel.system('which hg > /dev/null')
      abort 'mercurial is required to install.'
    end
    return true
  end

  def check_tag
    unless get_version
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
    return $*.find { |v| v =~ /(^start$|^tip$|^v7-.+$|^system$|^latest$)/ }
  end

  def version_include?(version)
    return Version.versions.include?(version)
  end
end

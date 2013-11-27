module Validator
  module_function

  def check_hg
    unless Kernel.system('which hg > /dev/null')
      abort 'mercurial is required to install.'
    end
    return true
  end

  def check_tag(tag = $*[1])
    unless tag =~ /(^start$|^tip$|^v7-.+$|^system$|^latest$)/
      abort 'undefined vim version. please run [ vvm-rb list ].'
    end
    return true
  end

  def new_version?(versions, version = $*[1])
    if version_include?(versions, version)
      abort "#{version} is already installed."
    end
    return true
  end

  def version_exist?(versions, version = $*[1])
    unless version_include?(versions, version)
      abort "#{version} is not installed."
    end
    return true
  end

  private

  def version_include?(versions, version)
    return versions.include?(version)
  end
end

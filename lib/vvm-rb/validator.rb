module Validator
  module_function

  def check_hg
    unless Kernel.system('which hg > /dev/null')
      abort 'mercurial is required to install.'
    end
    return true
  end

  def check_tag
    unless $*[1] =~ /(^start$|^tip$|^v7-.+$|^system$)/
      abort 'undefined vim version. please run [ vvm-rb list ].'
    end
    return true
  end
end

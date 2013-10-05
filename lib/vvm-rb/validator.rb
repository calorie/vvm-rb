module Validator
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def before_method(*names)
      names.each do |name|
        m = instance_method(name)
        define_method(name) do |*args, &block|
          yield
          m.bind(self).call(*args, &block)
        end
      end
    end

    def check_hg
      unless Kernel.system('hg --version > /dev/null')
        abort 'mercurial is required to install.'
      end
      return true
    end

    def check_tag
      unless $*[1] =~ /(^start$|^tip$|^v7-.+$|^system$)/
        abort 'undefined vim version. please run [ vvm-rb list ] and check available versions.'
      end
      return true
    end
  end
end

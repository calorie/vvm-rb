module VvmRb
  module Base
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
    end
  end
end

module Lab42
  module AOP extend self
    module Meta extend self
      def add_singleton_method objct, name, &method
        class << objct; self end.module_eval do
          define_method name, &method
        end
        objct
      end

      def add_attribute objct, att_name
        class << objct; self end.module_eval do
          attr_accessor att_name
        end
        objct
      end
    end # module Meta
  end # module AOP
end # module Lab42

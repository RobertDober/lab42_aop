module Lab42
  module AOP extend self
    module Meta extend self
      def add_singleton_method objct, name, &method
        class << objct; self end.module_eval do
          define_method name, &method
        end
      end
    end # module Meta
  end # module AOP
end # module Lab42

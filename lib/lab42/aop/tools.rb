module Lab42
  module AOP extend self
    module Tools extend self
      def mk_result_wrapper bound_mthd, name
        result = nil
        wrapper = -> *a, &b do
          wrapper.result = bound_mthd.( *a, &b )
        end
        Meta.add_singleton_method( wrapper, :name ){ name }
        Meta.add_attribute( wrapper, :result )
      end

    end # module Tools
  end # module AOP
end # module Lab42

module Lab42
  module AOP
    module Before extend self
      def with_methods rcv, tgts, aops
        Array( tgts ).each do | tgt |
          Array( aops ).each do | aop |
          _define_method_before rcv, tgt, aop
        end
        end
      end

      private
      def _define_method_before rcv, tgt, aop
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          send( aop, *a, &b )
          original_method.bind( self ).( *a, &b )
        end
      end
    end # module Before
  end # module AOP
end # module Lab42

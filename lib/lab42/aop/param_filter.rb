module Lab42
  module AOP
    module ParamFilter extend self
      def with_block rcv, tgts, &blk
        Array( tgts ).each do | tgt |
          _define_block_before rcv, tgt, blk
        end
      end

      def with_methods rcv, tgts, aops
        Array( tgts ).each do | tgt |
          Array( aops ).each do | aop |
          _define_method_before rcv, tgt, aop
        end
        end
      end

      private
      def _define_block_before rcv, tgt, blk
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          new_params = blk.(*a)
          original_method.bind( self ).( *new_params, &b )
        end
        
      end

      def _define_method_before rcv, tgt, aop
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          new_params = send( aop, *a )
          original_method.bind( self ).( *new_params, &b )
        end
      end
    end # module ParamFilter
  end # module AOP
end # module Lab42

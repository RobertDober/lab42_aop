module Lab42
  module AOP
    module ResultFilter extend self
      def with_block rcv, tgts, &blk
        Array( tgts ).each do | tgt |
          _define_block_result_filter rcv, tgt, blk
        end
      end

      def with_methods rcv, tgts, aops
        Array( tgts ).each do | tgt |
          Array( aops ).each do | aop |
          _define_method_result_filter rcv, tgt, aop
        end
        end
      end

      private
      def _define_block_result_filter rcv, tgt, blk
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          blk.( original_method.bind( self ).( *a, &b ), *a, &b )
        end
        
      end

      def _define_method_result_filter rcv, tgt, aop
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          aop_method = method aop
          if aop_method.arity < 0
            aop_method.( original_method.bind( self ).( *a, &b ), *a, &b )
          else
            aop_method.( original_method.bind( self ).( *a, &b ), &b )
          end
        end
      end
    end # module ResultFilter
  end # module AOP
end # module Lab42

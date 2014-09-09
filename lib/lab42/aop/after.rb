module Lab42
  module AOP
    module After extend self
      def with_block rcv, tgts, &blk
        Array( tgts ).each do | tgt |
          _define_block_after rcv, tgt, blk
        end
      end

      def with_methods rcv, tgts, aops
        Array( tgts ).each do | tgt |
          Array( aops ).each do | aop |
          _define_method_after rcv, tgt, aop
        end
        end
      end

      private
      def _define_block_after rcv, tgt, blk
        original_method = rcv.instance_method tgt
        unique_name = "__#{tgt}_#{SecureRandom.uuid.gsub('-','_')}"
        rcv.send :define_method, unique_name, &blk
        rcv.send :define_method, tgt do |*a, &b|
          original_method.bind( self ).( *a, &b ).tap do
            send unique_name, *a, &b
          end
        end
        
      end

      def _define_method_after rcv, tgt, aop
        original_method = rcv.instance_method tgt
        rcv.send :define_method, tgt do |*a, &b|
          original_method.bind( self ).( *a, &b ).tap do
            send( aop, *a, &b )
          end
        end
      end
    end # module After
  end # module AOP
end # module Lab42

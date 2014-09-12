module Lab42
  module AOP
    module After extend self
      def with_block rcv, tgts, **kwds, &blk
        concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
        concerns.each do | tgt_concern |
          _define_block_after tgt_concern, blk
        end
      end

      def with_methods rcv, tgts, aops, **kwds
        Array( aops ).each do | aop |
          concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
          concerns.each do | tgt_concern |
            _define_method_after tgt_concern, aop
          end
        end
      end

      private
      def _define_block_after tgt_concern, blk
        unique_name = "__#{tgt_concern.name}_#{SecureRandom.uuid.gsub('-','_')}"
        tgt_concern.cls.send :define_method, unique_name, &blk
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          tgt_concern.mthd.bind( self ).( *a, &b ).tap do
            send unique_name, *a, &b
          end
        end
        
      end

      def _define_method_after tgt_concern, aop
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          tgt_concern.mthd.bind( self ).( *a, &b ).tap do
            send( aop, *a, &b )
          end
        end
      end
    end # module After
  end # module AOP
end # module Lab42

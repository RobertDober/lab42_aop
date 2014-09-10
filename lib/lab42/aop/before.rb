
module Lab42
  module AOP
    module Before extend self
      def with_block rcv, tgts, &blk
        concerns = CrossConcern.get_methods rcv, Array( tgts )
        concerns.each do | tgt_concern |
          _define_block_before tgt_concern, blk
        end
      end

      def with_methods rcv, tgts, aops
        # aops loop must be outer loop as _define_method_before will change
        # the result of CrossConcern.get_methods rcv, ...
        Array( aops ).each do | aop |
          concerns = CrossConcern.get_methods rcv, Array( tgts )
          concerns.each do | tgt_concern |
            _define_method_before tgt_concern, aop
          end
        end
      end

      private
      def _define_block_before tgt_concern, blk
        unique_name = "__#{tgt_concern.name}_#{SecureRandom.uuid.gsub('-','_')}"
        tgt_concern.cls.send :define_method, unique_name, &blk
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          send unique_name, *a, &b
          tgt_concern.mthd.bind( self ).( *a, &b )
        end

      end

      def _define_method_before tgt_concern, aop
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          send( aop, *a, &b )
          tgt_concern.mthd.bind( self ).( *a, &b )
        end
      end
    end # module Before
  end # module AOP
end # module Lab42

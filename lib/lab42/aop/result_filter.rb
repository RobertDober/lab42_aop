module Lab42
  module AOP
    module ResultFilter extend self
      def with_block rcv, tgts, **kwds, &blk
        concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
        concerns.each do | tgt_concern |
          _define_block_result_filter tgt_concern, blk
        end
      end

      def with_methods rcv, tgts, aops, **kwds
        Array( aops ).each do | aop |
          concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
          concerns.each do | tgt_concern |
            _define_method_result_filter tgt_concern, aop
          end
        end
      end

      private
      def _define_block_result_filter tgt_concern, blk
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          blk.( tgt_concern.mthd.bind( self ).( *a, &b ), *a, &b )
        end

      end

      def _define_method_result_filter tgt_concern, aop
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          aop_method = method aop
          if aop_method.arity < 0
            aop_method.( tgt_concern.mthd.bind( self ).( *a, &b ), *a, &b )
          else
            aop_method.( tgt_concern.mthd.bind( self ).( *a, &b ), &b )
          end
        end
      end
    end # module ResultFilter
  end # module AOP
end # module Lab42

module Lab42
  module AOP
    module ParamFilter extend self
      def with_block rcv, tgts, **kwds, &blk
        concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
        concerns.each do | tgt_concern |
          _define_block_param_filter tgt_concern, blk
        end
      end

      def with_methods rcv, tgts, aops, **kwds
        Array( aops ).each do | aop |
          concerns = CrossConcern.get_methods rcv, Array( tgts ), **kwds
          concerns.each do | tgt_concern |
            _define_method_param_filter tgt_concern, aop
          end
        end
      end

      private
      def _define_block_param_filter tgt_concern, blk
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          new_params = blk.(*a)
          tgt_concern.mthd.bind( self ).( *new_params, &b )
        end
      end

      def _define_method_param_filter tgt_concern, aop
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          new_params = send( aop, *a )
          tgt_concern.mthd.bind( self ).( *new_params, &b )
        end
      end
    end # module ParamFilter
  end # module AOP
end # module Lab42

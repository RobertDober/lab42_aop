module Lab42
  module AOP
    module Around extend self
      def with_block rcv, tgts, &blk
        concerns = CrossConcern.get_methods rcv, Array( tgts )
        concerns.each do | tgt_concern |
          _define_block_around tgt_concern, blk
        end
      end

      def with_methods rcv, tgts, aops
        Array( aops ).each do | aop |
          concerns = CrossConcern.get_methods rcv, Array( tgts )
          concerns.each do | tgt_concern |
            _define_method_around tgt_concern, aop
          end
        end
      end

      private
      def _define_block_around tgt_concern, blk
        unique_name = "__#{tgt_concern.name}_#{SecureRandom.uuid.gsub('-','_')}"
        tgt_concern.cls.send :define_method, unique_name, &blk
        result = nil
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          result_wrapper = -> (*args, &inner_blk) do
            result = tgt_concern.mthd.bind( self ).(*args, &inner_blk)
          end
          Meta.add_singleton_method( result_wrapper, :name ){ tgt_concern.name }
          send unique_name, result_wrapper, *a, &b
          result
        end
      end

      def _define_method_around tgt_concern, aop
        result = nil
        tgt_concern.cls.send :define_method, tgt_concern.name do |*a, &b|
          result_wrapper = -> (*args, &inner_blk) do
            result = tgt_concern.mthd.bind( self ).(*args, &inner_blk)
          end
          Meta.add_singleton_method( result_wrapper, :name ){ tgt_concern.name }
          send aop, result_wrapper, *a, &b
          result
        end
      end
    end # module Around
  end # module AOP
end # module Lab42

require_relative 'aop/after'
require_relative 'aop/before'
require_relative 'aop/param_filter'

module Lab42
  module AOP
    def after *args, &blk
      if blk
        After.with_block( self, *args, &blk )
      else
        After.with_methods( self, *args )
      end
    end
    def before *args, &blk
      if blk
        Before.with_block( self, *args, &blk )
      else
        Before.with_methods( self, *args )
      end
    end

    def param_filter *args, &blk
      if blk
        ParamFilter.with_block( self, *args, &blk )
      else
        ParamFilter.with_methods( self, *args )
      end
    end
  end # module AOP
end # module Lab42

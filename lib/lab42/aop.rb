require_relative 'aop/meta'
require_relative 'aop/tools'

require_relative 'aop/cross_concern'
# require_relative 'aop/concern_scope'

require_relative 'aop/after'
require_relative 'aop/around'
require_relative 'aop/before'
require_relative 'aop/param_filter'
require_relative 'aop/result_filter'


module Lab42
  module AOP
    def after *args, **kwds, &blk
      if blk
        After.with_block( self, *args, **kwds, &blk )
      else
        After.with_methods( self, *args, **kwds )
      end
    end
    def around *args, **kwds, &blk
      if blk
        Around.with_block( self, *args, **kwds, &blk )
      else
        Around.with_methods( self, *args, **kwds )
      end
    end
    def before *args, **kwds, &blk
      if blk
        Before.with_block( self, *args, **kwds, &blk )
      else
        Before.with_methods( self, *args, **kwds )
      end
    end

    # def concern_scope &blk
    #   _scopes << Module.new(&blk) # Just to know the methods defined
    #   module_eval &blk
    # ensure
    #   _scopes.pop
    # end

    def param_filter *args, **kwds, &blk
      if blk
        ParamFilter.with_block( self, *args, **kwds, &blk )
      else
        ParamFilter.with_methods( self, *args, **kwds )
      end
    end

    def result_filter *args, **kwds, &blk
      if blk
        ResultFilter.with_block( self, *args, **kwds, &blk )
      else
        ResultFilter.with_methods( self, *args, **kwds, &blk )
      end
    end

    def _scopes; @__scopes__ ||= [] end
  end # module AOP
end # module Lab42

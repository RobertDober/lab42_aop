require_relative 'aop/before'

module Lab42
  module AOP
    def before *args, &blk
      if blk
        Before.with_block( self, *args, &blk )
      else
        Before.with_methods( self, *args )
      end
    end
  end # module AOP
end # module Lab42

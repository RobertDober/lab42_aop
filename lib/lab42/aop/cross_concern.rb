require 'ostruct'

module Lab42
  module AOP extend self
    module CrossConcern extend self
      def get_methods cls, mthd_specs 
        mthd_specs
          .map{ |ms| _get_methods cls, ms }
          .flatten
          .compact
          .uniq
      end

      private
      def _get_methods cls, mthd_spec
        case mthd_spec
        when Symbol
          _make_concern cls, mthd_spec
        when String
          _get_methods cls, %r{#{mthd_spec}}
        when Regexp
          cls
            .instance_methods
            .grep( mthd_spec )
            .map{ |ms| _make_concern cls, ms }
        end
      end

      def _make_concern cls, mthd_spec
        OpenStruct.new cls: cls, name: mthd_spec, mthd: cls.instance_method( mthd_spec ) 
      rescue
        nil
      end

    end # module CrossConcern
  end # module AOP
end # module Lab42

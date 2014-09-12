require 'ostruct'

module Lab42
  module AOP extend self
    module CrossConcern extend self
      def get_methods cls, mthd_specs, **kwds 
        mthd_specs
        .map{ |ms| _get_methods cls, ms, **kwds }
        .flatten
        .compact
        .uniq
      end

      private
      def _exclude_candidates candidates, exclude
        case exclude
        when Array
          candidates - exclude
        when Symbol
          candidates - Array( exclude )
        end
      end
      def _get_methods cls, mthd_spec, include_included: false, exclude: nil
        candidates = _get_methods_candidates cls, mthd_spec, include_included: include_included
        candidates = _exclude_candidates( candidates, exclude ) if exclude
        _make_concerns( cls, candidates )
      end

      def _get_methods_candidates cls, mthd_spec, include_included: false
        case mthd_spec
        when Symbol
          [ mthd_spec ]
        when String
          cls
          .instance_methods( include_included )
          .grep( %r{#{mthd_spec}} )
        when Regexp
          cls
          .instance_methods( include_included )
          .grep( mthd_spec )
        when Module
          mthd_spec
          .instance_methods( include_included )
        end
      end

      def _make_concerns cls, mss
        mss.map{ |ms| _make_concern cls, ms }
      end
      def _make_concern cls, mthd_spec
        OpenStruct.new cls: cls, name: mthd_spec, mthd: cls.instance_method( mthd_spec ) 
      rescue
        nil
      end

    end # module CrossConcern
  end # module AOP
end # module Lab42


class Class
  alias_method :new_method, :define_method
  public :new_method
end

RSpec.configure do | c |
  c.before do
    self.class.subject do
      class_under_test.new
    end
    self.class.let :class_under_test do
      Class.new.extend( AOP ).tap do | klass |
        # Implement automatic access to instance variables
        klass.send :define_method, :method_missing do |name, *args, &b|
          super name, *args, &b if name.size > 1 || !args.empty? || b
          instance_variable_get "@#{name}".sub(/\A@@/,'@')
        end
        # Implement an on_init class method
        class << klass
          def on_init &blk
            @__class__on_inits ||= []
            @__class__on_inits << blk
          end
          def new *args, &blk
            o = allocate
            ( @__class__on_inits || []).each do | class_init |
              o.instance_eval( &class_init )
            end
            o.send( :initialize, *args, &blk )
            o
          end
        end
      end
    end
  end
end

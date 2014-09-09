# Lab42::AOP

## Acceptance Test Suite

_Warning:_ These demos are not written for readability, given how readable the others are
you should be aware of what is ahead...

### A Class with all filters and ascpects

```ruby
    class A1
      extend AOP

      attr_accessor :n
      # targets
      def before_with_after n
        self.n + n
      end 
      alias_methods *(1..3).map{|n| "before_with_after_#{n}"}, from: :before_with_after

      # aspects
      def set_n n
        self.n = n
      end
      def unset_n *args
        self.n = nil
      end
      before :before_with_after, :set_n
      after  :before_with_after, :unset_n
    end

    a1 = A1.new
    a1.before_with_after( 21 ).assert == 42
    a1.n.assert.nil?
```


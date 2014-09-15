# Lab42::AOP

## Acceptance Test Suite

_Warning:_ These demos are not written for readability, given how readable the others are
you should be aware of what is ahead...

### A Class with all filters and aspects

```ruby
    class A1
      extend AOP

      attr_accessor :n
      # targets
      def before_with_after n
        self.n + n
      end 
      # alias_methods *(1..3).map{|n| "before_with_after_#{n}"}, from: :before_with_after

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

Now we add a paramter filter

```ruby
    class A1
      param_filter :before_with_after, &:succ
    end

    a1 = A1.new
    a1.before_with_after( 20 ).assert == 42
    a1.n.assert.nil?

```

and a parameter filter and a result filter

```ruby
    class A1
      def add1 n; n.succ end
      
      param_filter :before_with_after, :add1
      result_filter :before_with_after do |x| x*2 end
    end
    
    a1 = A1.new
    a1.before_with_after( 20 ).assert == 88
    a1.n.assert.nil?
```

### Module with aspects

```ruby
    module AM1
      extend AOP
      def inc a; a + count end
      around :inc do | concern, a |
        @count ||= 0
        @count += a
        concern.( a )
        @count += a
      end
    end # AM1
```

Can be included with the aspects defined inside and it applies to includees:

```ruby
    class A2
      attr_reader :count
      include AM1
    end 
    a2 = A2.new 
    a2.inc(21).assert == 42 
    a2.count.assert == 42 
    A2.new.inc(10).assert == 20
```

### Singletons with aspects

#### Module Singletons

```ruby
    module AM2 extend self
      extend AOP
      def sum a, b; a + b end
      result_filter :sum do |r| 2 * r end
      param_filter :sum do |a, b| [a+1,b+1] end
    end

    AM2.sum( 1, 2 ).assert == 10
```

It still works if included

```ruby
    class A3
      include AM2
    end
    A3.new.sum( 1, 2 ).assert == 10
```

or extending

```ruby
    module AM3 extend AM2
    end
    class A4
      extend AM2
    end
    AM3.sum( 1, 2 ).assert == 10
    A4.sum( 3, 2 ).assert == 14
```

or _weired_ combinations thereof

```ruby
    class A5
      extend AM3
    end
    A4.sum( 2, 2 ).assert == 12
   
    o = Object.new.extend AM3
    o.sum( 3, 3 ).assert == 16
```






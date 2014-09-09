# Lab42 AOP Aspect Oriented Programming

## Param Filter

Contrary to `Before` hoox these are not executed in the objects context (well they are if they are specified as methods)
but that is an undefined side effect you shall not rely on.

`Param Filters'` purpose is to transform the parameters, this kind of transfomation can be easily demonstrated, e.g. to eliminate
_illegal_ values from the inputs

```ruby
    class D
      extend AOP
      attr_reader :message

      def sum *values
        values.reduce :+
      end

      param_filter :sum do |*values|
        @message = "I am not here, really"
        values.map(&:to_i)
      end
    end

    d = D.new
    d.sum( *%W{ one 2 three 4 } ).assert == 6
```

We also added an assignment to `@message` in order to be able to demonstrate that the filter block is **not** executed
in the receiver's context:

```ruby
    d.message.assert == nil
```

### Nesting and different types

As with _Before_ aspects we can nest the hoox and that regardingless of their type, and of course can the filters
change the parameter geometry:

```ruby
    module E extend self
      extend AOP
      def collect *parts
        parts
      end
      def add_one
        [1]
      end
      def add_two *orig
        orig + [2]
      end
      param_filter :collect do | *orig |
        orig + [0]
      end
      param_filter :collect, [:add_two, :add_one]
    end

    E.collect.assert == [1, 2, 0]
```

Passing of arrays can be a little bit tricky. We need an extra
level of wrapping sometimes, as each filter calls the next with a splash.
This behavior is Ruby's semantics though and not introduced by this gem.

```ruby
    module F extend self
      extend AOP
      def size ary
        ary.size
      end
      param_filter :size do | ary |
        # Note the wrapper here
        [ ary + ary ]
      end
    end

    F.size([*1..2]).assert == 4
```

There is a functional test in [param-filter](???)



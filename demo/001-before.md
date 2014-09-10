# Lab42 AOP Aspect Oriented Programming

## Before

Before aspects are used to execute code in the context of the receiving objects **before** a method.

This code is executed for its side effects as the parameters are passed into all aspects and the 
eventual method _identically_.

The code of an aspect can be specified by means of the name of a different method (à la Rails) or
by a code block.

Here is a most simple example:

```ruby
    class A
      extend AOP
      attr_reader :a, :b
      def bef_a
        @a ||= 0
        @a += 1
      end
      
      before :a, :bef_a
      before :b do
        @b ||= 1
        @b *= 2
      end
    end

    a = A.new
    a.a.assert == 1
    a.b.assert == 2
    a.b.assert == 4
    a.a.assert == 2
      
```

### Nesting Before Aspects

As might be not so surprising the before hoox ( and all other in this gem ) are executed in reverse order of definition.

They can be defined as blox or methods of course.

Let us demonstrate:

```ruby
      class B
        attr_accessor :c
        extend AOP
        def double_c
          @c *= 2
        end
        before :c, :double_c
        before :c do
          @c += 1
        end

        private
        def initialize initial_c
          self.c = initial_c
        end
      end

      B.new(20).c.assert == 42
```

### Parameter Handling

As mentioned above parameters and block parameters are passed into all hoox and the eventual method invocation.
That does not mean we cannot use them inside the hoox. Here as a demonstration of a (useful?) application of that fact:

```ruby
    module C extend self
      extend AOP
      def process values, &blk
        blk.( values, @stored )
      end
      before :process do | values, &blk |
        @stored = blk.( values, nil )
      end
    end

    C.process(0..9){ |values, stored|
      if stored
        values.zip(stored).map{|a,b|a+b}.reduce :+
      else
        @stored = values.map{1}
      end
    }.assert == 55
```

## Specifying the Cross Concern

All this is nice and might be useful, but the **real** power of AOP is to specify cross concerns, e.g. all methods starting with an `a` 

Here are some examples how to specify that kind of behavior:

```ruby
    class CC
      extend AOP
      attr_reader :count
      
      def a1; end
      def a2; end
      def b1; end
      before %r{\Aa} do
        @count ||= 0
        @count += 1
      end
    end

    cc = CC.new
    cc.a1
    cc.a2
    cc.b1
    cc.b1
    cc.a2
    cc.count.assert == 3

```


# Lab42::AOP Aspect Oriented Programming

## Around Aspects

Like `before` and `after` aspects, `around` aspects are executed for their side effects.

Unlike its two sibblings it is not _automatic_ what _around_ means, here is a simple example:

```ruby
    class I
      extend AOP
      attr_reader :a
      def main a
        @a += a
      end
      
      around :main do |*args|
        @a = 0
        # here we want to invoke the concern, but how?
        # magical_invocation_of_concern 
        @a += 1
      end 
    end
```

We can see that  the concern was not invoked, and yes, the above is legal code.

```ruby
    i = I.new
    i.main 41
    i.a.assert == 1 # and not 42, sigh
```

We opted for a very simple approach, the concern is simply passed in as first postional parameter

```ruby
    class I
      def main2 a
        @a += a
      end
      around :main2 do |concern, a|
        @a = 0
        concern.( a )
        @a += 1
      end
    end

```

We can see now, that the result of `main2` is not altered by the concern, however the code is correctly
executed _around_ the concern.

```ruby
    i.main2( 41 ).assert == 41
    i.a.assert == 42
```




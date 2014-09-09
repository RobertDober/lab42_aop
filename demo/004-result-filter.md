# Lab42::AOP Aspect Oriented Programming

## Result Filters

As Parameter Filter they are not executed inside the receivers context but have a purely functional (pun intended)
transformation effect on the result of the method. Like `after` aspects they are executed in definition order.

Here is proof for what I just said:

```ruby
    class H
      extend AOP
      attr_reader :a
      def double n; n * 2 end

      result_filter :double do |r|
        @a = r
        r.succ
      end
    end

    h = H.new

    h.double(21).assert == 43 # What a shame, though

    # Again we proof that the context was not the one from h
    h.a.assert.nil?
```


# Lab42::AOP

Aspect Oriented Programming

## After Aspect

After hooks are symmetrical to Before hooks, so there is not much to demonstrate, just a nested hook
with block params maybe:

```ruby
    class G
      extend AOP
      attr_reader :called

      def main n, &blk
        blk.(called) unless called > 1
      end

      def inc_called n, &blk
        @called += blk.( n )
      end

      after :main, :inc_called

      def initialize
        @called = 0
      end
    end

    g = G.new
    g.main(1){|x| x}.assert == 0
    g.main(1){|x| x}.assert == 1
    g.main(1){|x| x}.assert.nil?
```

And if we nest now

```ruby
    class G
      after :main do |n, &blk|
        @called += blk.(n)
      end
    end
    g = G.new
    g.main(1){|x| x}.assert == 0
    g.main(1){|x| x}.assert.nil?
```




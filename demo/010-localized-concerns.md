# Lab42::AOP Aspect Oriented Programming

## Localized Concerns

Up to know, we have seen how to define an aspect for concerns. The way concerns are defined are, however,
limited to lists and regular expression matches.

Although what we have shown so far has value, it also has shortcomings. It would, for example, be an important
violation of design priniciples if we had to name our methods accordingly to accomodate concerns.

It seems to us, that combining the features of this gem with the means of behavior composition already provided
by _Ruby_ will give it its full power.

A group of methods, forming a concern is clearly a candidate for a module, the following, rather primitive example
should nevertheless be a convinient use case:

```ruby

    module Logger extend self
      def log *args
        args.empty? ? _log : (_log << args)
      end
      def _log
        @__log__ ||= []
      end
    end

    # Behavior to notify listeners
    module MessageSender
      def broadcast msg
        listeners.each{ |listener| _send listener, msg }
      end

      def send_msg listener, msg
        _send listener, msg
      end

      # A concern meaning all methods of this module
      extend AOP
      around self do |concern, *args|
        Logger.log :in, concern.name, *args
        concern.( *args )
        Logger.log :out, concern.name
      end
      private
      def _send listener, msg; end
    end
```

When including the `MessageSender` into a class, we will see the _around_ _concern_ is perfectly localized

```ruby
    class Worker
      # Not a concern of around self
      def do_something
      end

      include MessageSender
      def listeners; %w{alpha beta} end
    end
```

Now, after all these bold statements, let us prove them.

```ruby
    worker = Worker.new
    worker.do_something # No logging
    worker.broadcast "to all"        # should log "in|out broadcast (to all)" twice
    worker.send_msg "gamma", "hello" # should log "in|out send_msg (gamma hello)" twice

    Logger.log.assert == [
      [:in, :broadcast, "to all"],
      [:out, :broadcast],
      [:in, :send_msg, "gamma", "hello"],
      [:out, :send_msg],
    ]

```

### Using Around for the access to the concern only

It makes perfect sense to use an `around` aspect for `before` or `after` concerns if one needs
to access the concern (as we did not want to clutter the other APIs).

A part of messaging, we might want to save messages to a kind of persistent storage, and we still want
to log this.

```ruby
    module Storage
      def store msg
        storage << msg
      end
      def storage; @__storage__ ||= [] end
    end
```

We will use the Storage module as a mixin, for every object needs its own storage. Nevertheless
we will use the module as a Concern. (Imagine that there is not _one_ `store` method but many)

```ruby
    class Worker
      include Storage
      extend AOP
      around Storage, exclude: :storage do |concern, *args|
        concern.( *args )
        Logger.log "#{concern.name}: #{args.inspect}"
      end
    end
```

Again, please imagine a complex `Storage`  module with a plethora of `store_*` methods.

```ruby
    Logger.log.clear
    worker = Worker.new

    worker.store 42
    worker.storage.assert == [42] # N.B. No logging here
    Logger.log.assert == [ ["store: [42]"] ]
```



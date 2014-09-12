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




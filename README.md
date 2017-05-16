# Testing Race Condition

This is a demo app that shows you how to test race condition. You can find the example specs in 
`./specs/models/user_spec.rb`

## TL;DR (or too bored didn't listen)

Here are the steps:

1. Spawn multiple threads to run the same code block

```ruby
threads = 4.times.map do
  Thread.new do
    # code goes here
  end
end
```

2. Create a flag and make all the threads wait for instantiation of others

```ruby
waiting_for_others = true

threads = 4.times.map do
  Thread.new do
    # this runs an infinit loop until waiting_for_others is set to false
    true while waiting_for_others

    # code goes here
  end
end

set the flag to false so all the threads will start executing the logic
waiting_for_others = false

# join all the threads back to the main threada
threads.each(&:join)
```

3. If you use DatabaseCleaner, set strategy to `:truncation` for race conditions specs

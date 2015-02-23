## v1.0

Microscope no longer adds instance methods based on the "imperative" grammatical mood.

It now adds the `mark_as_<verb>!` instance method which does the same thing as
the `mark_as_<verb>` method but then calls `save!` on the record.

```ruby
# Before 1.0
class Event < ActiveRecord::Base
  acts_as_microscope
end

event = Event.new(started_on: nil)

event.mark_as_started
event.started_on # => 2015-02-23T07:58:31-0500
event.reload.started_on # => nil

event.start!
event.reload.started_on # => 2015-02-23T07:58:31-0500

# After 1.0
class Event < ActiveRecord::Base
  acts_as_microscope
end

event = Event.new(started_on: nil)

event.mark_as_started
event.started_on # => 2015-02-23T07:58:31-0500
event.reload.started_on # => nil

event.start! # NoMethodError
event.mark_as_started!
event.reload.started_on # => 2015-02-23T07:58:32-0500
```

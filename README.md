<div align="center">
  <img src="https://user-images.githubusercontent.com/11348/55957273-e1a0a580-5c33-11e9-9eb7-edb896fbbeaf.png" width="600" alt="Microscope" />
  <p><br />Microscope adds useful scopes targeting ActiveRecord <code>boolean</code>, <code>date</code> and <code>datetime</code> attributes.</p>
  <p>
    <a href="https://travis-ci.com/mirego/microscope"><img src="https://travis-ci.com/mirego/microscope.svg?branch=master" /></a>
    <a href="https://rubygems.org/gems/microscope"><img src="https://img.shields.io/gem/v/microscope.svg" /></a>
  </p>
</div>

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microscope'
```

## Usage

```ruby
create_table "events" do |t|
  t.string   "name"
  t.boolean  "special"
  t.datetime "expired_at"
  t.date     "archived_on"
end

class Event < ApplicationRecord
  acts_as_microscope
end

Event.special
# SELECT * FROM `events` where `events`.`special` = 1

Event.not_special
# SELECT * FROM `events` where `events`.`special` = 0

Time.now
# => 2013-07-05 15:43:42

Event.expired_before(2.months.ago)
# SELECT * FROM `events` where `events`.`expired_at` < '2013-05-05 15:43:42'

Event.expired_before_now
# SELECT * FROM `events` where `events`.`expired_at` < '2013-07-05 15:43:42'

Event.expired_after_or_now
# SELECT * FROM `events` where `events`.`expired_at` >= '2013-07-05 15:43:42'

Event.expired_after_or_at(2.months.from_now)
# SELECT * FROM `events` where `events`.`expired_at` >= '2013-09-05 15:43:42'

Event.expired_between(2.months.ago..1.month.from_now)
# SELECT * FROM `events` where `events`.`expired_at` BETWEEN '2013-05-05 15:43:42' AND '2013-08-05 15:43:42'

Event.archived_before(2.days.ago)
# SELECT * FROM `events` where `events`.`archived_on` < '2013-07-03'

Event.archived_between(2.days.ago..3.days.from_now)
# SELECT * FROM `events` where `events`.`archived_on` BETWEEN '2013-07-03' AND '2013-07-08'

Event.archived
# SELECT * FROM `events` where `events`.`archived_on` IS NOT NULL AND `events`.`archived_on` <= '2013-07-05 15:43:42'

Event.not_archived
# SELECT * FROM `events` where `events`.`archived_on` IS NULL OR `events`.`archived_on` > '2013-07-05 15:43:42'
```

Microscope also adds a few instance methods to the model per scope.

```ruby
event = Event.archived.first
# SELECT * FROM `events` where `events`.`archived_on` IS NOT NULL AND `events`.`archived_on` <= '2013-07-05 15:43:42' LIMIT 1

event.archived? # => true
event.not_archived? # => false

event = Event.unarchived.first
event.archived? # => false

event.mark_as_archived
event.archived? # => true
event.archived_at # => 2013-07-05 15:43:42
event.reload
event.archived? # => false
event.archived_at # => nil

event.mark_as_archived! # (same as #mark_as_archived but save the record immediately)
event.archived? # => true
event.archived_at # => 2013-07-05 15:43:42
event.reload
event.archived? # => true
event.archived_at # => 2013-07-05 15:43:42
```

### Options

#### On `acts_as_microscope`

You can also use a few options when calling `acts_as_microscope`:

```ruby
class Event < ApplicationRecord
  acts_as_microscope only: [:created_at]
end

class User < ApplicationRecord
  acts_as_microscope except: [:created_at]
end

Event.created_before(2.months.ago) # works!
Event.updated_before(2.months.ago) # NoMethodError

User.created_before(2.months.ago) # NoMethodError
User.updated_before(2.months.ago) # works!
```

### Date and time attributes and forms

When using Microscope on a `date` or `datetime` attribute, you’ll probably want
avoid dealing with those values in forms and only expose a checkbox to the
user.

Setting a Microscope-enabled attribute to a [_truthy_ value](https://github.com/mirego/microscope/blob/master/lib/microscope/utils.rb#L5)
will correctly cast the attribute to the right value (`Date.today` or `Time.now`, respectively). Otherwise the attribute will
be set to `nil`.

#### Model

```ruby
class Event < ApplicationRecord
  acts_as_microscope
end
```

#### View

```erb
<% form_for @event do |form| %>
  <%= form.text_field :name %>
  <%= form.check_box :archived? %>

  <%= submit_tag %>
<% end %>
```

#### Controller

```ruby
class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.save
  end

  def event_params
    params.require(:event).permit(:name, :archived)
  end
end
```

## License

`Microscope` is © 2013-2019 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/microscope/blob/master/LICENSE.md) file.

The microscope logo is based on [this lovely icon](http://thenounproject.com/noun/microscope/#icon-No9056) by [Scott Lewis](http://thenounproject.com/iconify), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](https://www.mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](https://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](https://www.mirego.org).

We also [love open-source software](https://open.mirego.com) and we try to give back to the community as much as we can.

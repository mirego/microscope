# Microscope

[![Gem Version](https://badge.fury.io/rb/microscope.png)](https://rubygems.org/gems/microscope)
[![Build Status](https://travis-ci.org/mirego/microscope.png?branch=master)](https://travis-ci.org/mirego/microscope)

Microscope adds useful scopes targeting ActiveRecord boolean, date and datetime fields.

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
  t.date     "started_on"
end

class Event < ActiveRecord::Base
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

Event.expired_after_or_at(2.months.from_now)
# SELECT * FROM `events` where `events`.`expired_at` >= '2013-09-05 15:43:42'

Event.expired_between(2.months.ago..1.month.from_now)
# SELECT * FROM `events` where `events`.`expired_at` BETWEEN '2013-05-05 15:43:42' AND '2013-08-05 15:43:42'

Event.started_before(2.days.ago)
# SELECT * FROM `events` where `events`.`started_on` < '2013-07-03'

Event.started_between(2.days.ago..3.days.from_now)
# SELECT * FROM `events` where `events`.`started_on` BETWEEN '2013-07-03' AND '2013-07-08'

Event.started
# SELECT * FROM `events` where `events`.`started_at` NOT NULL AND `events`.`started_at` <= '2013-07-05 15:43:42'

Event.not_started
# SELECT * FROM `events` where `events`.`started_at` IS NULL OR `events`.`started_at` > '2013-07-05 15:43:42'
```

### Options

You can use a few options when calling `acts_as_microscope`:

```ruby
class Event < ActiveRecord::Base
  acts_as_microscope, only: [:created_at]
end

class User < ActiveRecord::Base
  acts_as_microscope, except: [:created_at]
end

Event.created_before(2.months.ago) # works!
Event.updated_before(2.months.ago) # NoMethodError

User.created_before(2.months.ago) # NoMethodError
User.updated_before(2.months.ago) # works!
```

## License

`Microscope` is © 2013 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/microscope/blob/master/LICENSE.md) file.

## About Mirego

Mirego is a team of passionate people who believe that work is a place where you can innovate and have fun. We proudly build mobile applications for [iPhone](http://mirego.com/en/iphone-app-development/ "iPhone application development"), [iPad](http://mirego.com/en/ipad-app-development/ "iPad application development"), [Android](http://mirego.com/en/android-app-development/ "Android application development"), [Blackberry](http://mirego.com/en/blackberry-app-development/ "Blackberry application development"), [Windows Phone](http://mirego.com/en/windows-phone-app-development/ "Windows Phone application development") and [Windows 8](http://mirego.com/en/windows-8-app-development/ "Windows 8 application development") in beautiful Quebec City.

We also love [open-source software](http://open.mirego.com/) and we try to extract as much code as possible from our projects to give back to the community.

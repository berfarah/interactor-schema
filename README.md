# Interactor::Schema

[![Build Status](https://img.shields.io/travis/berfarah/interactor-schema/master.svg?style=flat-square)](https://travis-ci.org/berfarah/interactor-schema)

Interactor::Schema provides an enforcable Interactor Context via a `schema`
class method.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'interactor'
gem 'interactor-schema'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install interactor-schema

## Usage

See [here](https://github.com/collectiveidea/interactor) for the official
Interactor documentation.


### Setup

When you include `Interactor::Schema`, you are able to define a schema for valid
context methods using the `schema` DSL method.

```rb
class SaveUser
  include Interactor::Schema
  schema :name
end
```

### Calling methods

When the attribute is part of the valid schema, you will have no problems
accessing it as usual:

```rb
context = SaveUser.call(name: "Bob")
context.name
# => "Bob"
```

For attributes outside the schema, you will get `NoMethodError`s. The same thing
applies when trying to set an attribtue outside of the schema.

```rb
context = SaveUser.call(age: 28)
context.age
# NoMethodError: undefined method 'age' for #<SaveUser:0x007f9521298b10>
```

### Use with `Organizer`s

`Interactor::Schema` works great with `Interactor::Organizer`s!

```rb
class SaveUser
  include Interactor::Schema
  include Interactor::Organizer

  schema :name
  organize ValidateInfo, SendMailer
end

class ValidateInfo
  include Interactor

  def call
    # These will work, since name is in our schema
    context.name
    context.name = "Bob"

    # These will fail with NoMethodErrors since age is not in our schema
    context.age
    context.age = 28
  end
end
```

The initial schema will be propagated through the entire chain, meaning no
attributes outside of `name` can be set. This is particularly helpful for
maintaining clarity of what information is being consumed by a chain of
`Interactor`s.

### Multiple Schemas

In the case of multiple schemas being provided only the first one will be used
(others will be discarded). The idea is that you should have clarity before you
run an `Interactor` chain what information will be set.

Modifying the schema in the middle of the chain could result in confusing
behavior.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/interactor-schema.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


# HippieCsv

HippieCsv is a wrapper around the Ruby `CSV` library, enhancing support for unusual and malformed files.

## Installation

Add this line to your application's Gemfile:

    gem 'hippie_csv'

And then execute:

    $ bundle

And then test:

    $ bundle exec rspec

Or install it yourself as:

    $ gem install hippie_csv

## Usage

```ruby
> HippieCsv.parse("/path/to/file")
# => [["foo", "bar", "baz"]]
```

## Contributing

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so we can cherry-pick around it.

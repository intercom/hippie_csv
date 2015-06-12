# HippieCsv

## Build status

[ ![Codeship Status for intercom/hippie_csv](https://codeship.com/projects/f3b188e0-f312-0132-75cb-5ed004d44c71/status?branch=master)](https://codeship.com/projects/85324)

Ruby's `CSV` is great. It complies with the [CSV spec](http://example.com/)
pretty well. If you pass its methods bad or incompliant CSVs, it’ll rightfully
and loudly complain. It’s great 👍

Except…if you want to be able to deal with files from the real world. At
[Intercom](https://intercom.io), we’ve seen lots of problematic CSVs from
customers importing data to our system. You may want to support such cases.
You may not always know the delimiter, nor the chosen quote character, in
advance.

HippieCsv is a ridiculously tolerant and liberal parser which aims to yield as
much usable data as possible out of such real-world CSVs.

## Installation

Add this line to your application's Gemfile:

    gem 'hippie_csv'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hippie_csv

## Usage

Exposes two public methods: `read` (for paths to files), and `parse` (for
strings).

```ruby
require 'hippie_csv'

HippieCsv.read("./data.csv")

HippieCsv.parse(csv_string)
```

## Features

- Deduces the delimiter (supports `,`, `;`, and `|`)
- Deduces the quote character (supports `'` and `"`)
- Forgives backslash escaped quotes in quoted CSVs
- Forgives invalid newlines in quoted CSVs
- Heals many encoding issues (and aggressively forces UTF-8)
- Deals with many miscellaneous malformed types of CSVs
- Works when a [byte order mark](http://example.com) is present

## Contributing

1. Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
2. Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
3. Fork the project.
4. Start a feature/bugfix branch.
5. Commit and push until you are happy with your contribution.
6. Make sure to add tests for it. This is important so we don't break it in a future version unintentionally.
7. Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so we can cherry-pick around it.

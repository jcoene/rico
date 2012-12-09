# Rico

Rico provides primative data types on Riak.

## Installation

Add rico to your Gemfile and `bundle install`:

```ruby
gem "rico"
```

## Usage

Instantiate a Rico object with a **bucket** and a **key** then perform operations.

Here's an example of how to use a set to manage a list of followed users:

```ruby
follows = Rico::Set.new "follows", @user.id

follows.member? @other_user.id  # => false

follows.add @other_user.id

follows.member? @other_user.id  # => true
follows.length                  # => 1

follows.remove @other_user.id

follows.member? @other_user.id  # => false
follows.length                  # => 0
```

## Configuration

By default, Rico uses a generic Riak::Client instance for operations. You can specify your own (perhaps inside of a rails initializer) like so:

```ruby
Rico.configure do |c|
  c.riak = Riak::Client.new(http_port: 1234, ...)
end
```

You can also provide a namespace to be used as a key prefix:

```ruby
Rico.configure do |c|
  c.namespace = "development"             # => "development:BUCKET:KEY"
  c.namespace = ["my_app", "production"]  # => "my_app:production:BUCKET:KEY"
end
```

## Data Types

**Arrays** - sequence of values

```ruby
a = Rico::Array.new "bucket", "key"
a.add [3, 1, 1, 4, 2]
a.members   # => [3, 1, 1, 4, 2]
a.length    # => 5
```

**Lists** - sorted sequence of values

```ruby
l = Rico::List.new "bucket", "key"
l.add [3, 1, 1, 4, 2]
l.members   # => [1, 1, 2, 3, 4]
l.length    # => 5
```

**Sets** - unique sequence of values

```ruby
s = Rico::Set.new "bucket", "key"
s.add [3, 1, 1, 4, 2]
s.members   # => [3, 1, 4, 2]
s.length    # => 4
```

**Sorted Sets** - unique, sorted sequence of values

```ruby
s = Rico::SortedSet.new "bucket", "key"
s.add [3, 1, 1, 4, 2]
s.members   # => [1, 2, 3, 4]
s.length    # => 4
```

**Values** - generic serialized values

```ruby
v = Rico::Value.new "bucket", "key"
v.exists?   # => false
v.get       # => nil
v.set "bob"
v.get       # => "bob"
v.exists?   # => true
```

## Notes

### Enumerable

Enumerable-looking types are indeed Enumerable

### Serialization

Data is serialized using the Riak client libary provided by Basho, which serializes values as JSON and sets a Content-Type value of "application/json"

### Persistence

Data is persisted at operation time. For example, List#add(5) will immediately update the record in Riak. It'd generally be wise to compute a list of values to be added or removed and then issue a single operation.

## TODO

- Automatic sibling resolution for simple types
- Ability to provide sibling resolution callback

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2012 Jason Coene

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Rico

[![Build Status](https://secure.travis-ci.org/jcoene/rico.png?branch=master)](https://travis-ci.org/jcoene/rico)

Rico provides simple data types persisted to Riak.

Supports Array, List, Set, SortedSet, Map, SortedMap, CappedSortedMap, Value objects.

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

By default, Rico uses a generic Riak::Client instance for operations. You can specify your own options for the Riak client (perhaps inside of a rails initializer) like so:

```ruby
Rico.configure do |c|
  c.options = { http_port: 1234, ... }
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

**Maps** - key-value mappings

```ruby
m = Rico::Map.new "bucket", "key"
m.add({"a" => 1})
m.add({"b" => 2, "c" => 3})
m.members   # => {"a" => 1, "b" => 2, "c" => 3}
m.length    # => 3
```

**Sorted Maps** - key-value mappings sorted by key

```ruby
m = Rico::SortedMap.new "bucket", "key"
m.add({"b" => 2, "c" => 3})
m.add({"a" => 1})
m.members   # => {"a" => 1, "b" => 2, "c" => 3}
m.length    # => 3
```

**Capped Sorted Maps** - key-value mappings sorted by key and bound by size

```ruby
m = Rico::CappedSortedMap.new "bucket", "key", limit: 2
m.add({"b" => 2, "c" => 3})
m.add({"a" => 1})
m.members   # => {"b" => 2, "c" => 3}
m.length    # => 2
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

## Content Types

**JSON**: Objects are serialized and stored as JSON by default, using a Content-Type header of `application/json`

**JSON+gzip**: Objects can be serialized and stored as JSON and then compressed with gzip by specifying a Content-Type header of `application/x-json`. Note that it is not currently possible non-JSON data with the gzip content header using Rico.

```ruby
s = Rico::Set.new "bucket", "key"
s.content_type = "application/x-gzip"
s.add [1,2,3]
s.get       # => [1, 2, 3]
s.raw_data  # => "\u001F\x8B\b\u0000G...."
```

## Notes

### Enumerable

Enumerable-looking types are indeed Enumerable

### Persistence

Data is persisted at operation time. For example, List#add(5) will immediately update the record in Riak. It'd generally be wise to compute a list of values to be added or removed and then issue a single operation.

## TODO

- Ability to provide custom sibling resolution callbacks

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

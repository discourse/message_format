# MessageFormat

A wrapper gem for the `@messageformant/core` [npm package](https://www.npmjs.com/package/@messageformat/core) to compile MessageFormat messages.

This gem uses [`mini_racer`](https://github.com/rubyjs/mini_racer) to call the `@messageformat/core` npm package.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add messageformat-wrapper --require messageformat

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install messageformat-wrapper

## Usage

```ruby
require "messageformat"

messages =
  {
    a: "A {TYPE} example.",
    b: "This has {COUNT, plural, one{one member} other{# members}}.",
    c: "We have {P, number, percent} code coverage.",
  }
MessageFormat.compile("en", messages)
# Will output:
#
# import { number, plural } from "@messageformat/runtime";
# import { en } from "@messageformat/runtime/lib/cardinals";
# import { numberPercent } from "@messageformat/runtime/lib/formatters";
# export default {
#   a: (d) => "A " + d.TYPE + " example.",
#   b: (d) => "This has " + plural(d.COUNT, 0, en, { one: "one member", other: number("en", d.COUNT, 0) + " members" }) + ".",
#   c: (d) => "We have " + numberPercent(d.P, "en") + " code coverage."
# }
```

Syntactically-broken messages will raise a `MessageFormat::Compiler::CompileError` exception.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, update the `CHANGELOG.md` file, and commit the changes and push to GitHub. Our GitHub Action will then take care of pushing the new version to rubygems.org.

Instructions for updating the distributed copy of `@messageformat/core` that's included with this gem can be found in the README in the `messageformat-miniracer` directory.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/discourse/messageformat. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/discourse/messageformat/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MessageFormat project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/discourse/messageformat/blob/main/CODE_OF_CONDUCT.md).

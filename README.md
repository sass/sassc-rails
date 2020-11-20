# SassC::Rails [![Build Status](https://travis-ci.org/sass/sassc-rails.svg)](https://travis-ci.org/sass/sassc-rails) [![Gem Version](https://badge.fury.io/rb/sassc-rails.svg)](http://badge.fury.io/rb/sassc-rails)

We all love working with Sass, but compilation can take quite a long time for larger
codebases.  This gem integrates the C implementation of Sass,
[LibSass](https://github.com/sass/libsass), into the asset pipeline.

In one larger project, this made compilation 4x faster:

```
# Using sassc-rails

[1] pry(main)> Benchmark.bm { |bm| bm.report { Rails.application.assets["application.css"] } }
       user     system      total        real
   1.720000   0.170000   1.890000 (  1.936867)

# Using sass-rails

 [1] pry(main)> Benchmark.bm { |bm| bm.report { Rails.application.assets["application.css"] } }
       user     system      total        real
  7.820000   0.250000   8.070000 (  8.106347)
```

This should essentially be a drop in alternative to [sass-rails](https://github.com/rails/sass-rails).

## Inline Source Maps

With SassC-Rails, it's also extremely easy to turn on inline source maps. Simply
add the following configuration to your development.rb file:

```ruby
# config/environments/development.rb
config.sass.inline_source_maps = true
```

After adding this config line, you may need to clear your assets cache
(`rm -r tmp/cache/assets`), stop spring, and restart your rails server.  You may
also wish to disable line comments (`config.sass.line_comments = false`).

Note, as indicated, these source maps are *inline*.  They will not generate additional
files or anything like that.  Instead, they will be appended to the compiled
application.css file.

## LibSass Compatibility With Ruby Sass

For a look at the compatibility between Ruby Sass and LibSass, check this
[compatibility chart](http://sass-compatibility.github.io/) out.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sassc-rails'
```

And then execute:

    $ bundle

## Configuration

To configure Sass via Rails set use `config.sass` in your
application and/or environment files to set configuration
properties that will be passed to Sass.

### Options

- `preferred_syntax` - This option determines the default Sass syntax and file extensions that will be used by Rails generators. Can be `:scss` (default CSS-compatible SCSS syntax) or `:sass` (indented Sass syntax).

The [list of supported Sass options](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html#options)
can be found on the Sass Website with the following caveats:

- `:style` - This option is not supported. This is determined by the Rails environment. It's `:expanded` only on development, otherwise it's `:compressed`.
- `:never_update` - This option is not supported. Instead set `config.assets.enabled = false`
- `:always_update` - This option is not supported. Sprockets uses a controller to access stylesheets in development mode instead of a full scan for changed files.
- `:always_check` - This option is not supported. Sprockets always checks in development.
- `:syntax` - This is determined by the file's extensions.
- `:filename` - This is determined by the file's name.
- `:line` - This is provided by the template handler.

### Example
```ruby
MyProject::Application.configure do
  config.sass.preferred_syntax = :sass
  config.sass.line_comments = false
  config.sass.cache = false
end
```

## Important Note

Sprockets provides some directives that are placed inside of comments called `require`, `require_tree`, and
`require_self`. **<span style="color:#c00">DO NOT USE THEM IN YOUR SASS/SCSS FILES.</span>** They are very
primitive and do not work well with Sass files. Instead, use Sass's native `@import` directive which
`sassc-rails` has customized to integrate with the conventions of your Rails projects.

## Features

### Glob Imports

When in Rails, there is a special import syntax that allows you to
glob imports relative to the folder of the stylesheet that is doing the importing.

* `@import "mixins/*"` will import all the files in the mixins folder
* `@import "mixins/**/*"` will import all the files in the mixins tree

Any valid ruby glob may be used. The imports are sorted alphabetically.

**NOTE:** It is recommended that you only use this when importing pure library
files (containing mixins and variables) because it is difficult to control the
cascade ordering for imports that contain styles using this approach.

### Asset Helpers
When using the asset pipeline, paths to assets must be rewritten.
When referencing assets use the following asset helpers (underscored in Ruby, hyphenated
in Sass):

#### `asset-path($relative-asset-path)`
Returns a string to the asset.

* `asset-path("rails.png")` returns `"/assets/rails.png"`

#### `asset-url($relative-asset-path)`
Returns a url reference to the asset.

* `asset-url("rails.png")` returns `url(/assets/rails.png)`

As a convenience, for each of the following asset classes there are
corresponding `-path` and `-url` helpers:
image, font, video, audio, javascript, stylesheet.

* `image-path("rails.png")` returns `"/assets/rails.png"`
* `image-url("rails.png")` returns `url(/assets/rails.png)`

#### `asset-data-url($relative-asset-path)`
Returns a url reference to the Base64-encoded asset at the specified path.

* `asset-data-url("rails.png")` returns `url(data:image/png;base64,iVBORw0K...)`

## Running Tests

    $ bundle install
    $ bundle exec rake test

If you need to test against local gems, use Bundler's gem :path option in the Gemfile and also edit `test/support/test_helper.rb` and tell the tests where the gem is checked out.

## Common Issues

### Deployment to Heroku

Due to LibSass compilation requirements, you must upgrade to the
[Heroku Cedar-14 Stack](https://devcenter.heroku.com/articles/cedar-14-migration)
in order to successfully install this gem.

Upgrading to Cedar-14 is usually a painless process.


### Installing alongside a gem that depends on Sass-Rails

Libraries explicitly depending on Sass-Rails can cause
conflicts with installation of SassC-Rails.  While we have no built-in solution
for this, please check out [this issue](https://github.com/sass/sassc-rails/issues/6)
for a workaround.


## Credits

This gem is based on [sass-rails](https://github.com/rails/sass-rails), and
is maintained by [Ryan Boland](https://ryanboland.com) and [awesome contributors](https://github.com/sass/sassc-rails/graphs/contributors).


## Changelog

- **2.1.2**
  - [Correct reference to SassC::Script::Value::String](https://github.com/sass/sassc-rails/pull/129)
- **2.1.1**
  - [Fix Scaffolding](https://github.com/sass/sassc-rails/pull/119)
- **2.1.0**
  - [JRuby support](https://github.com/sass/sassc-rails/pull/113)
  - [SCSS / SASS scaffolding](https://github.com/sass/sassc-rails/pull/112)
- **2.0.0**
  - [Drop support for Sprockets 2](https://github.com/sass/sassc-rails/pull/109)
  - [Remove dependency on Ruby Sass](https://github.com/sass/sassc-rails/pull/109)
- **1.3.0**
  - [Silence Sprockets deprecation warnings](https://github.com/sass/sassc-rails/pull/76)
  - [Sprockets 4 compatibility](https://github.com/sass/sassc-rails/pull/65)
- **1.2.1**
  - Bump SassC (and thus LibSass) version
- **1.2.0**
  - [Support sprockets-rails 3](https://github.com/sass/sassc-rails/pull/41)
  - [Only depend on Railties instead of full Rails](https://github.com/sass/sassc-rails/pull/52)
- **1.1.0**
  - Moved under the official sass organization!
  - [Source line comments](https://github.com/sass/sassc-rails/pull/24) (`app.config.sass.line_comments`)
  - [Prevent sass-rails railtie from running](https://github.com/sass/sassc-rails/pull/34)
  - [CSS compression may be disabled in test mode](https://github.com/sass/sassc-rails/issues/33). Special thanks to [this Sass-Rails PR](https://github.com/rails/sass-rails/pull/338) for inspiration.
- **1.0.0**
  - Initial Release
  - Add support for inline source maps
  - Support compression in the way that Sass-Rails handles it


## Contributing

1. Fork it ( https://github.com/sass/sassc-rails/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Add Tests
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request

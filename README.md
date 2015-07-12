# SassC::Rails [![Build Status](https://travis-ci.org/bolandrm/sassc-rails.svg)](https://travis-ci.org/bolandrm/sassc-rails) [![Gem Version](https://badge.fury.io/rb/sassc-rails.svg)](http://badge.fury.io/rb/sassc-rails)

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

__Note:  This is a new project, please report any issues you come across!__

## Inline Source Maps

With SassC-Rails, it's also extremely easy to turn on inline source maps. Simply
add the following configuration to your development.rb file:

```ruby
# config/environments/development.rb
config.sass.inline_source_maps = true
```

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


## Deployment to Heroku

Due to LibSass compilation requirements, you must upgrade to the
[Heroku Cedar-14 Stack](https://devcenter.heroku.com/articles/cedar-14-migration)
in order to successfully install this gem.

Upgrading to Cedar-14 is usually a painless process.


## Installing alongside a gem that depends on Sass-Rails

Libraries explicitly depending on Sass-Rails, such as ActiveAdmin, can cause
conflicts with installation of SassC-Rails.  While we have no built-in solution
for this, please check out [this issue](https://github.com/bolandrm/sassc-rails/issues/6)
for a workaround.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/sassc-rails/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Add Tests
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request


## Credits

This gem is based on [sass-rails](https://github.com/rails/sass-rails), and
is maintained by [Ryan Boland](https://ryanboland.com) and [awesome contributors](https://github.com/bolandrm/sassc-rails/graphs/contributors).

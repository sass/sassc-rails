# SassC::Rails [![Build Status](https://travis-ci.org/bolandrm/sassc-rails.svg)](https://travis-ci.org/bolandrm/sassc-rails) [![Gem Version](https://badge.fury.io/rb/sassc-rails.svg)](http://badge.fury.io/rb/sassc-rails)

We all love working with Sass, but compilation can take quite a long time for larger
codebases.  This gem integrates the C implementation of Sass,
[libsass](https://github.com/sass/libsass), into the asset pipeline.

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

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sassc-rails'
```

And then execute:

    $ bundle


## Contributing

1. Fork it ( https://github.com/[my-github-username]/sassc-rails/fork )
1. Create your feature branch (`git checkout -b my-new-feature`)
1. Commit your changes (`git commit -am 'Add some feature'`)
1. Add Tests
1. Push to the branch (`git push origin my-new-feature`)
1. Create a new Pull Request

## Credits

This gem is based on [sass-rails](https://github.com/rails/sass-rails), and
is maintained by [Ryan Boland](https://ryanboland.com).

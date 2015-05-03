require "bundler/gem_tasks"

task :test do
  $LOAD_PATH.unshift('lib', 'test')
  Dir.glob('./test/**/*_test.rb') { |f| require f }
end

namespace :tests do
  gemfiles = %w[
    sprockets_2_12
    sprockets_3_0
    rails_4_2
    rails_4_1
    rails_4_0
    with_sass_rails
  ]

  gemfiles.each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake test"
    end
  end

  desc "Run Tests against all ORMs"
  task :all do
    gemfiles.each do |gemfile|
      puts "Running Tests against #{gemfile}"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake test"
    end
  end
end

# frozen_string_literal: true

require "bundler/setup"
require "byebug"
require "combustion"
require "database_cleaner"
require "rails/all"
require "rspec/rails"
require "shoulda-matchers"
require "rspec_examples"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start { coverage_dir("tmp/coverage") }
else
  puts "* testhq/coverage was required, but not configured using valid environment settings. No coverage reports will be generated. See https://github.com/OneHQ/testhq#code-coverage."
end

Combustion.initialize! :all do
  config.load_defaults 6.0
end

Combustion::Application.load_tasks

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# frozen_string_literal: true

require "bundler/setup"
require "byebug"
require "combustion"
require "database_cleaner"
require "rails/all"
require "rspec/rails"
require "shoulda-matchers"

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    coverage_dir("tmp/coverage")
   end
else
  puts "* testhq/coverage was required, but not configured using valid environment settings. No coverage reports will be generated. See https://github.com/OneHQ/testhq#code-coverage."
end

Combustion.initialize! :all do
  config.load_defaults 6.0
end

Combustion::Application.load_tasks

Dir[Rails.root.join("../support/*.rb")].each { |f| require f }

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

  config.extend Module.new {
    def has_validated_attribute(type, attr, *args, &block)
      it_behaves_like "#{ type.gsub("_", " ") } attribute", attr, *args, &block
    end

    # Provide dynamic methods wrappers to shared behaviors.
    #
    #=== Examples
    #  has_validated_name_field(:first_name)      # Same as `it_behaves_like "name attribute", :first_name`
    #  has_validated_zip_code_field(:first_name)  # Same as `it_behaves_like "zip code field", :first_name`
    def method_missing(name, *args, &block)
      if /\Ahas_validated_(?<type>\w*)_attribute\Z/ =~ name
        has_validated_attribute(type, *args, &block)
      else
        super
      end
    end
  }
end

require "active_support"
require "active_record"
require "has_normalized_attributes"
require "database_cleaner"
require "yaml"

ENV["debug"] = "test" unless ENV["debug"]

# Establish DB Connection
config = YAML::load(IO.read(File.join(File.dirname(__FILE__), "db", "database.yml")))
ActiveRecord::Base.configurations = {"test" => config[ENV["DB"] || "sqlite3"]}
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations["test"])

# Load Test Schema into the Database
load(File.dirname(__FILE__) + "/db/schema.rb")

# Load in our code
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

require "shoulda/matchers"
require "has_validated_attributes"
require "has_validated_attributes/rspec"

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

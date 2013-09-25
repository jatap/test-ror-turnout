require 'rubygems'
require 'spork'
require 'pry'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV['RAILS_ENV'] ||= 'test'

  unless ENV['DRB']
    require 'simplecov'
    require 'simplecov-gem-adapter'
    SimpleCov.start 'gem'
    # SimpleCov.start 'rails'
  end

  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'email_spec'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'factory_girl_rails'
  require 'database_cleaner'

  Rails.backtrace_cleaner.remove_silencers!

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    # Use the core set of syntax methods (build, build_stubbed, create,
    # attributes_for, and their *_list counterparts) without having to call them
    # on FactoryGirl directly
    config.include FactoryGirl::Syntax::Methods

    config.order = 'random'

    # Database cleaner
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

    # Request specs cannot use a transaction because Capybara runs in a
    # separate thread with a different database connection.
    # Reset so other non-request specs don't have to deal with slow truncation.
    config.before type: :request do
      DatabaseCleaner.strategy = :truncation
    end

    # EmailSpec
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    # Routing filter
    # RoutingFilter.active = false
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  if ENV['DRB']
    require 'simplecov'
    require 'simplecov-gem-adapter'
    SimpleCov.start 'gem'
    # SimpleCov.start 'rails'
  end

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
  FactoryGirl.reload
end

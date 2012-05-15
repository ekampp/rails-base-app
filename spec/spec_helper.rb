require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

#
# Custom matcher to check that the supplied url is present within the code and
# within a href attribute.
#
RSpec::Matchers.define :have_link_to do |expected|
  match do |actual|
    actual.include?("href=\"#{expected}\"")
  end

  failure_message_for_should do |actual|
    "expected #{actual} to contain link to #{expected}"
  end
end

#
# Logs the given +user+ in by returning the +user+ object when calling the
# +current_user+ method, and true when calling the +logged_in?+ method.
#
def login_with user
  controller.stub(:logged_in?).and_return true
  controller.stub(:current_user).and_return user
end

#
# Logs any existing user out, bu returning nil on the +current_user+ method and
# false on the +logged_in?+ method.
#
def logout
  controller.stub(:logged_in?).and_return false
  controller.stub(:current_user).and_return nil
end

#

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = true

    # Makes creating objects with factory girl less verbose, by allowing the
    # shorthand +create+ instead of +FactoryGirl.create+.
    config.include FactoryGirl::Syntax::Methods

    # Adss mongoid matchers
    config.include Mongoid::Matchers
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end

#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Base
require File.expand_path('../config/application', __FILE__)
Turnout::Application.load_tasks

Dir[File.join(File.dirname(__FILE__), 'tasks/**/*.rake')].each { |f| load f }

# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Verify that ACCOUNTS_SERVICE_URL AND NOTIFICATIONS_SERVICE_URL are set
raise 'ACCOUNTS_SERVICE_URL is not set' unless ENV['ACCOUNTS_SERVICE_URL']
raise 'NOTIFICATIONS_SERVICE_URL is not set' unless ENV['NOTIFICATIONS_SERVICE_URL']
raise 'NOTIFICATIONS_API_KEY is not set' unless ENV['NOTIFICATIONS_API_KEY']

# Initialize the Rails application.
Rails.application.initialize!

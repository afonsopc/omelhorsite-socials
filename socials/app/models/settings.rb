# frozen_string_literal: true

# rubocop:disable Lint/RedundantCopDisableDirective
# rubocop:disable Style/HashSyntax

# Settings
class Settings < ApplicationRecord
  def self.update_settings(user_id, settings_params)
    return if user_id.nil?

    Settings
      .where(user_id: user_id)
      .first_or_initialize
      .update(settings_params)
  end

  def self.user_settings(user_id)
    Settings
      .select(:allow_friend_requests, :allow_non_friend_messages)
      .where(user_id: user_id)
      .first_or_initialize
      .attributes
      .except('id', 'user_id', 'created_at', 'updated_at')
  end
end

# rubocop:enable Style/HashSyntax
# rubocop:enable Lint/RedundantCopDisableDirective

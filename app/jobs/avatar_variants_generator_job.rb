# frozen_string_literal: true

class AvatarVariantsGeneratorJob < ApplicationJob
  sidekiq_options retry: 1

  def perform(user_id)
    user = User.find(user_id)

    return unless user.avatar.attached?

    User::AVATAR_VARIANTS.each do |_key, value|
      user.avatar.variant(resize_to_limit: value).processed
    end
  end
end

# frozen_string_literal: true

# RootController
class RootController < ApplicationController
  def index
    # rubocop:disable Layout/LineLength
    render plain: "Se a tristeza ao fado assiste\nE o fado assim nos extasia\nPrefiro ser sempre triste\nPara não morrer de alegria",
           status: :ok
    # rubocop:enable Layout/LineLength
  end
end

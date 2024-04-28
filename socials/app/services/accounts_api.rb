# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# AccountsApi
class AccountsApi < ApplicationApi
  attr_accessor :token

  def auth_token_from_headers(headers)
    authorization_header = headers['Authorization']

    return if authorization_header.nil?

    token = authorization_header.sub('Bearer', '').strip

    return if token.empty? || token.length == authorization_header.length

    @token = token

    token
  end

  def get_account_info(params)
    Rails.logger.info("Getting account info with params: #{params}")

    send_request(
      "#{ENV['ACCOUNTS_SERVICE_URL']}/account",
      :get,
      @token,
      {},
      params
    )
  end

  def user_id_exists?(user_id)
    params = "id=#{user_id}"
    response = get_account_info(params)

    response.code == '200'
  end

  def user_id
    return nil unless @token

    params = 'info_to_get[id]=true'
    response = get_account_info(params)

    parse_response_for_user_id(response)
  end

  private

  def parse_response_for_user_id(response)
    return nil unless response.code == '200'

    id = JSON.parse(response.body)['id']

    return nil if id.nil? || id.empty?

    id
  end
end

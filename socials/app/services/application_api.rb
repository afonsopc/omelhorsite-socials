# frozen_string_literal: true

# ApplicationApi
class ApplicationApi
  def send_request(uri, method, token, body, params)
    return if uri.nil? && method.nil?

    Rails.logger.info("Sending request to #{uri}. " \
      "With the body: \"#{body}\";" \
      "With the params: \"#{params}\"; " \
      "#{token.nil? || token.empty? ? 'Without' : 'With'} token;")

    result = http_request(uri, method, token, body, params)
    uri = result[:uri]
    request = result[:request]

    req_options = { use_ssl: uri.scheme == 'https' }

    Net::HTTP.start(uri.hostname, uri.port, req_options) { |http| http.request(request) }
  end

  private

  def http_request(uri, method, token = nil, body = {}, params = '')
    uri = URI.parse(uri)
    uri.query = params unless params.nil? || params.empty?

    request = parse_method(method).new(uri)
    request['Authorization'] = "Bearer #{token}" unless token.nil? || token.empty?
    request.body = body.to_json unless body.nil? || body.empty?

    { uri:, request: }
  end

  def parse_method(method)
    case method
    when :get then Net::HTTP::Get
    when :post then Net::HTTP::Post
    when :put then Net::HTTP::Put
    when :delete then Net::HTTP::Delete
    else raise "Invalid method: #{method}"
    end
  end
end

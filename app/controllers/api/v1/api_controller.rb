# frozen_string_literal: true

require 'json_web_token'

class Api::V1::ApiController < ActionController::Base
  protect_from_forgery with: :null_session

  private

  def auth_header
    @auth_header ||= request.headers['Authorization']
  end

  def authenticate_registration # rubocop:disable Metrics/AbcSize
    if auth_header.present?
      # Auth header should look like:
      # Key XXYYZZZZYYXX
      # The Key should be the device's serial number concatenated with the
      # inverse.  So a device with serial number "123ABC" would have a key of
      # "123ABCCBA321".
      device_key = auth_header.split(' ').last
      valid_device_key = device_key.nil? ? false : device_key.length.even?

      if valid_device_key
        fwd, rev = device_key.chars.each_slice(device_key.length / 2).map(&:join)
        return true if fwd.reverse.eql?(rev)
      end
    end

    render json: { error: 'Invalid Device Key' }, status: :unauthorized
  end

  def authenticate_api
    return unless auth_header.present?

    # Auth header should look like:
    # Bearer XXYYZZ
    # We just want the token after 'Bearer'
    token = auth_header.split(' ')[-1]
    return unless token.present?

    @device = device_from_token(token)

    return if @device

    render json: { error: 'Invalid Token' }, status: :unauthorized
  end

  def device_from_token(token)
    decoded = JsonWebToken.decode(token)
    return nil unless decoded.present? && decoded.key?(:device_id)
    return nil unless Device.exists?(decoded[:device_id])

    Device.find(decoded[:device_id])
  end
end

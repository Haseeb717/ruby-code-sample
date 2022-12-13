# frozen_string_literal: true

module V1
  class DeviceSerializer < Blueprinter::Base
    require 'json_web_token'

    field :serial_number
    field :firmware_version
    field :token do |device|
      JsonWebToken.encode({ device_id: device.id })
    end
  end
end

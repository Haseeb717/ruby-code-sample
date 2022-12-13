# frozen_string_literal: true

require 'json_web_token'

class Api::V1::DevicesController < Api::V1::ApiController
  before_action do
    authenticate_registration
  end

  def create
    ## Task 1: Create a Device and return a JSON object with the following data
    #
    # {
    #   serial_number: "device serial number",
    #   firmware_version: "device firmware version",
    #   token: JWT encoded hash with { device_id: device.id }
    # }
    device = Device.find_or_initialize_by(device_params)
    if device.save
      render json: V1::DeviceSerializer.render(device)
    else
      render json: { errors: device.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def device_params
    params.require(:device).permit(:serial_number, :firmware_version)
  end
end

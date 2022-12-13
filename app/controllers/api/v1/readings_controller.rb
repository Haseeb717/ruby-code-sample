# frozen_string_literal: true

class Api::V1::ReadingsController < Api::V1::ApiController
  before_action do
    authenticate_api
    validate_create_params
  end
  MAX_READINGS_LIMIT = 500

  def create
    # Task 2: Record device readings.
    #
    # Return a `204 No Content` response if successful or a JSON object with errors.
    Reading.create(bulk_reading_params)
  end

  private

  def readings_params
    params.permit(readings: %I[temperature humidity co_level health timestamp]).require(:readings)
  end

  def bulk_reading_params
    bulk_params = readings_params.map { |e| e.merge('device_id': @device.id) } # Merging device id
    bulk_params.map { |i| i['recorded_at'] = i.delete :timestamp } # replace timestamp with recorded_at

    bulk_params
  end

  def validate_create_params
    return true if params[:readings] && params[:readings].size < MAX_READINGS_LIMIT

    render json: { errors: 'Invalid Parameters' }, status: :unprocessable_entity
  end
end

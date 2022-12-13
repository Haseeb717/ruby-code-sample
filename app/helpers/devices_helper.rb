# frozen_string_literal: true

module DevicesHelper
  def today_recorded_readings(device)
    device.readings.where(recorded_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
  end
end

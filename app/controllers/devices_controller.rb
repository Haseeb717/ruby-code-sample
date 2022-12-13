# frozen_string_literal: true

class DevicesController < ApplicationController
  private

  def devices
    @devices ||= Device.all
  end
  helper_method :devices

  def device
    @device ||= Device.find(params[:id])
  end
  helper_method :device
end

# frozen_string_literal: true

class Device < ApplicationRecord
  has_many :readings, dependent: :destroy

  validates :serial_number, presence: { message: 'is required' }
end

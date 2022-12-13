# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Device, type: :model do
  it { is_expected.to respond_to(:serial_number) }
end

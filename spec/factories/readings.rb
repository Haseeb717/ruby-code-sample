# frozen_string_literal: true

FactoryBot.define do
  factory :reading do
    name { 'temp' }
    value { '100' }
    device { nil }
  end
end

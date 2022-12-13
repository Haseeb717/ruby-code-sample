# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Device registration' do
  let(:device) { create(:device) }
  let(:params) do
    {
      device: {
        serial_number: device.serial_number,
        firmware_version: device.firmware_version
      }
    }
  end

  context 'when the request is authorized' do
    let(:headers) { { 'Authorization' => 'Bearer ABC123321CBA' } }

    context 'when registration succeeds' do
      before do
        post '/api/v1/devices', params: params, headers: headers
      end

      specify { expect(response).to have_http_status(:ok) }
      specify { expect(response.content_type).to eql('application/json; charset=utf-8') }

      it 'returns a JWT' do
        json = JSON.parse(response.body)
        expect(json['token']).not_to be_nil
      end
    end

    context 'when registration fails' do
      let(:invalid_params) do
        {
          device: {
            serial_number:    nil,
            firmware_version: device.firmware_version
          }
        }
      end

      before do
        post '/api/v1/devices', params: invalid_params, headers: headers
      end

      specify { expect(response).to have_http_status(:unprocessable_entity) }
    end
  end

  context 'when the request is not authorized' do
    let(:headers) { { 'Authorization' => 'INVALID' } }

    before do
      post '/api/v1/devices', params: params, headers: headers
    end

    specify { expect(response).to have_http_status(:unauthorized) }
  end
end

require 'rails_helper'

describe 'Health endpoint' do
  describe 'GET /health' do
    before { get '/health' }

    it 'shoult return OK' do
      payload = JSON.parse(response.body)
      expect(payload).not_to be_empty
      expect(payload['api']).to eq('OK')
    end

    it 'should retrun http status 200' do
      expect(response).to have_http_status(200)
    end
  end
end
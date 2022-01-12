require 'rails_helper'

RSpec.describe Post do
  describe 'GET /post ' do
    it 'with no data in DB and should return OK' do
      get 'post/'
      payload = JSON.parse(response.body)
      
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  

    context 'with data in the DB' do
      it 'should return all published post' do
        subject(:post) { create_list(:post, 10) }

        get 'post/'
        payload = JSON.parse(response.body)

        expect(payload.size).to eq(10)
        expect(response).to have_http_status(200)
      end

      it 'GET /post/{id} nd should return a post' do
        subject(:post) { create(:post) }

        get 'post/#{post.id}'
        payload = JSON.parse(response.body)

        expect(payload).not_to be_empty
        expect(payload['id']).to eq(post.id)
        expect(response).to have_http_status(200)
      end
    end
  end
end
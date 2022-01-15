require 'rails_helper'
require 'byebug'

RSpec.describe Post do
  describe 'GET /posts' do
    it 'with no data in DB and should return OK' do
      get '/posts'
      payload = JSON.parse(response.body)
      
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  

    context 'with data in the DB' do
      describe 'should return' do
        let!(:posts) { create_list(:post, 10, status: 'published') }
        it 'all published post' do

          get '/posts'
          payload = JSON.parse(response.body)

          expect(payload.size).to eq(10)
          expect(response).to have_http_status(200)
        end
      end

      describe 'GET /posts/{id}' do
        let!(:post) { create(:post) }
        it 'should return a post' do

          get "/posts/#{post.id}"
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(payload['id']).to eq(post.id)
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
require 'rails_helper'

RSpec.describe Post do
  describe 'GET /posts' do
    it 'with no data in DB and should return OK' do
      get '/posts'
      payload = JSON.parse(response.body)
      
      expect(payload).to be_empty
      expect(response).to have_http_status(200)
    end
  
    describe 'Search' do
      let!(:hellow_world) { create(:published_post, title: 'Hellow world') }
      let!(:hellow_rails) { create(:published_post, title: 'Hellow Rails') }
      let!(:malala_pitch) { create(:published_post, content: 'Hellow my name Malala') }
      let!(:exposing_api) { create(:published_post, title: 'Exposing an API') }

      it 'should fillter posts by title' do
        get "/posts?search=Hellow "
        payload = JSON.parse(response.body)
        
        expect(payload).not_to be_empty
        expect(payload.size).to eq(2)
        expect(payload.map{ |p| p['id'] }.sort).to eq([hellow_world.id, hellow_rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end

    context 'with data in the DB' do
      describe 'GET /posts' do
        let!(:posts) { create_list(:post, 10, status: 'published') }

        it 'should return all published post' do

          get '/posts'
          payload = JSON.parse(response.body)

          expect(payload.size).to eq(10)
          expect(response).to have_http_status(200)
        end
      end

      describe 'GET /posts/{id}' do
        let!(:post) { create(:post, status: 'published') }

        it 'should return a post' do

          get "/posts/#{post.id}"
          payload = JSON.parse(response.body)

          expect(payload).not_to be_empty
          expect(payload['id']).to eq(post.id)
          expect(payload['title']).to eq(post.title)
          expect(payload['content']).to eq(post.content)
          expect(payload['status']).to eq(post.status)
          expect(payload['author']['name']).to eq(post.user.name)
          expect(payload['author']['email']).to eq(post.user.email)
          expect(payload['author']['id']).to eq(post.user.id)
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end
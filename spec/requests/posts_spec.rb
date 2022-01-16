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

  describe 'POST /posts' do
    let!(:user) { create(:user) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          status: 'archived',
          user_id: user.id
        }
      }

      post '/posts', params: req_payload
      payload = JSON.parse(response.body)
      
      expect(payload).not_to be_empty
      expect(payload['id']).to be_present
      expect(response).to have_http_status(201)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          title: 'titulo',
          user_id: user.id
        }
      }

      post "/posts", params: req_payload
      payload = JSON.parse(response.body)
      
      expect(payload).not_to be_empty
      expect(payload['error']).to be_present
      expect(response).to have_http_status(422)
    end
  end

  describe 'PUT /post/{id}' do
    let!(:article) { create(:post) }

    it 'should create a post' do
      req_payload = {
        post: {
          title: 'titulo',
          content: 'content',
          status: 'published'
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      
      expect(payload).not_to be_empty
      expect(payload['id']).to eq(article.id)
      expect(response).to have_http_status(200)
    end

    it 'should return error message on invalid post' do
      req_payload = {
        post: {
          title: nil,
          content: nil,
          status: nil
        }
      }

      put "/posts/#{article.id}", params: req_payload
      payload = JSON.parse(response.body)
      
      expect(payload).not_to be_empty
      expect(payload['error']).to be_present
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
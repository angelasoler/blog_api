require 'rails_helper'

RSpec.describe 'Posts with authentication' do
  describe 'Get /posts/{id}' do
    context 'when requisting others author post' do
      context 'when post is public' do
        let!(:user) { create(:user) }
        let!(:other_user_published_post) { create(:published_post) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

        before { get "/posts/#{other_user_published_post.id}", headers: auth_headers }
        context 'payload' do
          subject { payload }

          it { is_expected.to include(:id) }
        end

        context 'response' do
          subject { response }

          it { is_expected.to have_http_status(200) }
        end
      end

      context 'when post is arquived' do
        let!(:user) { create(:user) }
        let!(:other_user_archived_post) { create(:archived_post) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

        before { get "/posts/#{other_user_archived_post.id}", headers: auth_headers }
        context 'payload' do
          subject { payload }

          it { is_expected.to include(:error) }
        end

        context 'response' do
          subject { response }

          it { is_expected.to have_http_status(404) }
        end
      end
    end
  end

  describe 'POST /posts' do
    context 'with valid authentication' do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      let!(:create_params) { { 'post' => {'title' => 'title', 'content' => 'content', 'status' => 'published'} } }
      before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

      before { post "/posts", params: create_params, headers: auth_headers }  
      context 'payload' do
        subject { payload }
        
        it { is_expected.to include(:id, :title, :content, :status, :author) }
      end

      context 'response' do
        subject { response }

        it { is_expected.to have_http_status(201) }
      end
    end

    context 'without authentication' do
      let!(:create_params) { { 'post' => {'title' => 'title', 'content' => 'content', 'status' => 'published'} } }
      before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

      before { post "/posts", params: create_params }
      context 'payload' do
        subject { payload }

        it { is_expected.to include(:error) }
      end

      context 'response' do
        subject { response }

        it { is_expected.to have_http_status(401) }
      end
    end
  end

  describe 'PUT /posts' do
    context 'with valid authentication' do
      context 'when updating users post' do
        let!(:user) { create(:user) }
        let!(:user_post) { create(:published_post, user_id: user.id) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:update_params) { { 'post' => {'title' => 'title', 'content' => 'content', 'status' => 'published'} } }
        before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

        before { put "/posts/#{user_post.id}", params: update_params, headers: auth_headers }
        context 'payload' do
          subject { payload }

          it { is_expected.to include(:id, :title, :content, :status, :author) }
          it { expect(payload[:id]).to eq(user_post.id) }
        end

        context 'response' do
          subject { response }

          it { is_expected.to have_http_status(200) }
        end
      end

      context 'when updating other users post' do
        let!(:user) { create(:user) }
        let!(:other_user_published_post) { create(:published_post) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:update_params) { { 'post' => {'title' => 'title', 'content' => 'content', 'status' => 'published'} } }
        before { allow(JsonWebToken).to receive(:verify).and_return([{email: user.email}]) }

        before { put "/posts/#{other_user_published_post.id}", params: update_params, headers: auth_headers }
        context 'payload' do
          subject { payload }

          it { is_expected.to include(:error) }
        end

        context 'response' do
          subject { response }

          it { is_expected.to have_http_status(404) }
        end
      end
    end
  end

  def payload
    JSON.parse(response.body).with_indifferent_access
  end
end
require 'rails_helper'

RSpec.describe 'Posts with authentication' do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:other_user_published_post) { create(:published_post, user_id: other_user.id) }
  let!(:other_user_archived_post) { create(:archived_post, user_id: other_user.id) }
  let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }

  describe 'Get /posts/{id}' do
    context 'when requisting others author post' do
      context 'when post is public' do
        before { get "/posts/#{other_user_published_post.id}", headers: auth_headers }

        context 'payload' do
          subject { JSON.parse(response.body).with_indifferent_access }

          it { is_expected.to include(:id) }
        end
        context 'response' do
          subject { response }
          it { is_expected.to have_http_status(200) }
        end
      end

      context 'when post is arquived' do
        before { get "/posts/#{other_user_archived_post.id}", headers: auth_headers }
        
        context 'payload' do
          subject { JSON.parse(response.body).with_indifferent_access }

          it { is_expected.to include(:error) }
        end
        context 'response' do
          subject { response }

          it { is_expected.to have_http_status(404) }
        end
      end
    end
  end
end
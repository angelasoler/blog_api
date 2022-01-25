module Secured
  def authenticate_user!
    if(Current.user = user_from_token)
      return
    end
    render json: { error: 'Unauthorized' }, status: 401
  rescue JWT::VerificationError, JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: 401
  end

  def user_from_token
    token = get_token_from_auth_header
    payload = JsonWebToken.verify(token).first.with_indifferent_access
    if payload.present?
      User.find_or_create_by(email: payload[:email]) do |user|
        user.name = payload[:name]
      end
    end
  end

  def get_token_from_auth_header
    token_regex = /Bearer (.+)/
    headers = request.headers
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      headers['Authorization'].match(token_regex)[1]
    end
  end
end
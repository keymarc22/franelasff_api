module Secured
  def authenticate_user!
    # authenticate header
    headers = request.headers
    token_regex = /^Bearer (\w+)/

    if headers[:authorization].present? && headers[:Authorization].match(token_regex)
      token = headers[:Authorization].match(token_regex)[1]
      Current.user = User.find_by(auth_token: token)
    end

    render json: { error: "Unauthorized" }, status: :unauthorized if Current.user.nil?
  end
end
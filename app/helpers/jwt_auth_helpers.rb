module JWTAuthHelpers
  def current_user
   user_info_from_header ? User.find_by(id: user_info_from_header["user_id"]) : nil
  rescue JWT::DecodeError
    nil
  end

  def authenticate_user!
    error!({message: "Authentication failure"}, 401) unless current_user
  end

  private
  def user_info_from_header
    return nil unless @user_info || (headers["Authorization"] && headers["Authorization"].split(" ").first == "Bearer")
    @user_info ||= AuthToken.decode headers["Authorization"].split(" ").last
  end
end

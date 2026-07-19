class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :track_user_login_redis

  private 

  # log user action login event 
  def track_user_login_redis
    if current_user
      $redis.zadd("users:online", Time.current.to_i, current_user.id)
    end
  end
end

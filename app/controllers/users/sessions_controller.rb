module Users
  class SessionsController < Devise::SessionsController
    before_action :redirect_if_authenticated, only: [:new]

    private

    def redirect_if_authenticated
      return unless user_signed_in?

      redirect_to root_path, alert: "You are already logged in!"
    end
  end
end

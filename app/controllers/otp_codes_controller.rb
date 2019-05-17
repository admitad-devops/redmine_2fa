class OtpCodesController < ApplicationController
  unloadable

  skip_before_action :check_if_login_required
  before_action :set_user_from_session

  def create # resend
    protocol&.send_code(@user)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_user_from_session
    if session[:otp_user_id]
      @user = User.find(session[:otp_user_id])
    else
      deny_access
    end
  end

  def protocol
    RedmineTwoFa::Protocols[user.two_fa]
  end
end

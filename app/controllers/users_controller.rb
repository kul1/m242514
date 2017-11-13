# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  def index
    @today = Date.today
    @xmains = current_ma_user.xmains.in(status:['R','I']).asc(:created_at)
  end

  def show
    ## Bugs as devise kick to show when logout
    session[:user_id] = nil
    # redirect_to '/mindapp/help'
    refresh_to root_path  end

  # mindapp methods
  def update_user
    # can't use session, current_ma_user inside mindapp methods
    $user.update_attribute :email, $xvars["enter_user"]["user"]["email"]
  end
  def change_password
    # check if old password correct
    identity = Identity.find_by :code=> $user.code
    if identity.authenticate($xvars["enter"]["epass"])
      identity.password = $xvars["enter"]["npass"]
      identity.password_confirmation = $xvars["enter"]["npass_confirm"]
      identity.save
      ma_log "Password changed"
    else
      ma_log "Unauthorized access"
    end
  end
def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
end

end

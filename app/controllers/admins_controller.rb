class AdminsController < ApplicationController
  def update_role
    user = User.find_by :code=> $xvars["select_user"]["code"]
    user.update_attribute :role, $xvars["edit_role"]["role"]
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

  def update_pwd
    u = User.find_by :id=> $xvars[:select_user][:usertag]
    u.update_attribute :code, $xvars[:edit_pwd][:pwd]
    $xvars[:email]= u.email
    #flash[:notice] = "แก้ไขรหัสผ่านเรียบร้อยแล้ว"
  end

end

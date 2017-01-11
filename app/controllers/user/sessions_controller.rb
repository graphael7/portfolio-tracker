class User::SessionsController < Devise::SessionsController
  respond_to :json

# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # create finds user by email and assigns auth_token, returns user object with token
  def create
    user = User.find_by(email: params[:user][:email])
    if user.valid_password?(params[:user][:password])
      user.set_new_authentication_token
      render :json => user.as_json, :status=>201
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end

  end

  # DELETE /resource/sign_out
  def destroy
    user = User.find_by(authentication_token: params[:authentication_token])
    user.remove_authentication_token
    session.clear
    render :json => {:success=>true, message:"You logged out!"}
  end

  protected

  def invalid_login_attempt
    warden.custom_failure!
    render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

class User::SessionsController < Devise::SessionsController
  respond_to :json
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    build_resource
    resource = User.find_for_database_authentication(login: params[:email][:login])
    if resource.nil?
      render :json => {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end

    if resource.valid_password?(params[:email][:password])
      sign_in("user", resource)
      render :json=> {:success=>true, :auth_token=>resource.authentication_token, :login=>resource.login, :email=>resource.email}
    else
      render :json=> {:success=>false, :message=>"Error with your login or password"}, :status=>401
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end

class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_dashboard, only: [:edit]

  def update
    @user = User.find(current_user.id)

    successfully_updated = update_user

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  private

  def set_dashboard
    @dashboard ||= DashboardPresenter.new(current_user)
  end

  def update_user
    if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end
  end

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :last_name, :gender, :birthday, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(
        :first_name,
        :last_name,
        :email,
        :gender,
        :birthday,
        :workload,
        :lunch_time,
        :warn_straight_hours,
        :warn_overtime,
        :warn_rest_period,
        :password,
        :password_confirmation,
        :current_password)
    end
  end

  def after_inactive_sign_up_path_for(_resource)
    new_user_registration_path
  end
end

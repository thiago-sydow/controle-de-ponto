class RegistrationsController < Devise::RegistrationsController
  include BeforeRender

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_render :set_presenter, except: [:new, :create]

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

  def update_user
    if needs_password?(@user, params)
      @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      fix_attributes
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
        :password,
        :password_confirmation,
        :current_password,
        accounts_attributes: [:id, :name, :workload, :lunch_time, :warn_straight_hours, :warn_overtime, :warn_rest_period, :hourly_rate, :allowance_time, :type, :_destroy])
    end
  end

  def after_inactive_sign_up_path_for(_resource)
    thank_you_path
  end

  private

  def fix_attributes
    params[:user][:accounts_attributes].values.each do |value|
      value["hourly_rate"] = value.fetch("hourly_rate").gsub('.', '').gsub(',', '.') if value.has_key? 'hourly_rate'
      fix_time_attributes(value)
      fix_warns_attributes(value)
    end
  end

  def fix_time_attributes(value)
    value["workload"] = time_to_seconds(value.fetch("workload")) if value.has_key? 'workload'
    value["lunch_time"] = time_to_seconds(value.fetch("lunch_time")) if value.has_key? 'lunch_time'
    value["allowance_time"] = time_to_seconds(value.fetch("allowance_time")) if value.has_key? 'allowance_time'
  end

  def fix_warns_attributes(value)
    value["warn_overtime"] = value.fetch("warn_overtime") == 'true' if value.has_key? 'warn_overtime'
    value["warn_rest_period"] = value.fetch("warn_rest_period") == 'true' if value.has_key? 'warn_rest_period'
    value["warn_straight_hours"] = value.fetch("warn_straight_hours") == 'true' if value.has_key? 'warn_straight_hours'
  end

  def time_to_seconds(time)
    hh, mm = time.split(':')
    (hh.to_i.hours + mm.to_i.minutes)
  end

end

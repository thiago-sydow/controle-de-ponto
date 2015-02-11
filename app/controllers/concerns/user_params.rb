class UserParams < Devise::ParameterSanitizer

  def sign_in
    default_params.permit(:email, :password, :remember_me)
  end

  def sign_up
    default_params.permit(:email, :password, :password_confirmation,
                          :name, :birthday, :job, :gender
                         )
  end
end

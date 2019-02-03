if Rails.env.development?
  user = User.new(
    first_name: 'Darth',
    last_name: 'Vader',
    email: 'vader@empire.com',
    password: 'empire_rulez',
    birthday: Date.parse('27/07/1990'),
    gender: :male
  )

  user.skip_confirmation!
  user.save!
end

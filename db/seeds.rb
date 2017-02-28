if Rails.env.development?
  application = Doorkeeper::Application.find_or_create_by!(
    name: 'Death Star API',
    redirect_uri: 'urn:ietf:wg:oauth:2.0:oob',
    uid: 'thisisalonguidwowsuch',
    secret: 'thisissalongsecretwowsuch'
  )

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

  Doorkeeper::AccessToken.find_or_create_by!(resource_owner_id: user.id, application_id: application.id)
end

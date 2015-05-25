class User
  include Mongoid::Document
  extend Enumerize

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  field :gender
  enumerize :gender, in: %w(male female), default: nil

  field :first_name, type: String
  field :last_name, type: String
  field :birthday, type: Date  

  ## Database authenticatable
  field :email,              type: String, default: ''
  field :encrypted_password, type: String, default: ''

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  validates_presence_of :first_name, :last_name, :birthday, :gender

  has_many :accounts

  accepts_nested_attributes_for :accounts, reject_if: :all_blank, allow_destroy: true

  def current_account
    accounts.active.first
  end

end

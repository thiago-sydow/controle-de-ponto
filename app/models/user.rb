class User
  include Mongoid::Document
  include Mongoid::Timestamps

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

  has_many :accounts, dependent: :delete
  accepts_nested_attributes_for :accounts, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :first_name, :last_name, :birthday, :gender

  before_validation :create_default_account
  after_save :check_current_account

  def current_account
    @current_account ||= accounts.active.first || check_accounts
  end

  def change_current_account_to(id)
    return unless accounts.count > 1
    current_account.update_attribute(:active, false)
    accounts.find(id).update_attribute(:active, true)
    @current_account = nil
  end

  private

  def check_accounts
    if accounts.blank?
      build_default_account
      save
      current_account
    else
      accounts.first.update_attributes(active: true)
    end
  end

  def create_default_account
    return unless new_record?
    build_default_account
  end

  def build_default_account
    accounts.build({ name: 'Emprego CLT', active: true }, CltWorkerAccount)
  end

  def check_current_account
    return if accounts.active.first
    accounts.first.update_attribute(:active, true)
  end

end

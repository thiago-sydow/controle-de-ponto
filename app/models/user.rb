class User < ActiveRecord::Base
  extend Enumerize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  enumerize :gender, in: %w(male female), default: nil

  has_many :accounts, dependent: :destroy
  accepts_nested_attributes_for :accounts, reject_if: :all_blank, allow_destroy: true

  belongs_to :current_account, class_name: Account.to_s

  validates_presence_of :first_name, :last_name, :birthday, :gender

  before_validation :create_default_account
  after_save :check_accounts

  def change_current_account_to(id)
    return unless accounts.count > 1
    update(current_account: accounts.find(id))
  end

  private

  def check_accounts
    return if current_account.present?

    if accounts.blank?
      build_default_account
      save
    end

    update(current_account: accounts.first)
  end

  def create_default_account
    return unless new_record?
    build_default_account
  end

  def build_default_account
    accounts.build(CltWorkerAccount.default_build_hash)
  end

end

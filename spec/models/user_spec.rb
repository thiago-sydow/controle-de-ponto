require 'rails_helper'

RSpec.describe User do

  it { expect(build(:user)).to be_valid }

  context 'associations' do
    it { expect(subject).to have_many :day_records }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of :email }
    it { expect(subject).to validate_uniqueness_of :email }
    it { expect(subject).to validate_presence_of :first_name }
    it { expect(subject).to validate_presence_of :last_name }
    it { expect(subject).to validate_presence_of :birthday }
    it { expect(subject).to validate_presence_of :gender }
    it { expect(subject).to validate_presence_of :workload }
  end

  context 'authenticate user' do
    let(:user) { create(:user) }

    it { expect(user.valid_password?('password')).to be }
    it { expect(user.valid_password?('falsepassword')).not_to be }
  end

end

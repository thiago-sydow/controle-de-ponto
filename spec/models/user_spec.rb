require 'rails_helper'

RSpec.describe User, type: :model do

  it { expect(create(:user)).to be_valid }
  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to validate_presence_of :name }
  it { expect(subject).to validate_presence_of :birthday }
  it { expect(subject).to validate_presence_of :job }
  it { expect(subject).to have_many :records }

  context 'authenticate user' do
    let(:user) { create(:user) }

    it { expect(user.valid_password?('password')).to be }
    it { expect(user.valid_password?('falsepassword')).not_to be }
  end

end

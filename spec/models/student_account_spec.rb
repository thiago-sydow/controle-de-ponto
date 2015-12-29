require 'rails_helper'

RSpec.describe StudentAccount, type: :model do

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :day_records }
    it { is_expected.to have_many :closures }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :workload }
  end

end

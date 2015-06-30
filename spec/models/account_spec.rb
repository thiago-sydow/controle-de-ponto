require 'rails_helper'

RSpec.describe Account, type: :model do

  context 'associations' do
    it { expect(subject).to belong_to :user }
    it { expect(subject).to have_many :day_records }
    it { expect(subject).to have_many :closures }
  end

  context 'validations' do
    it { expect(subject).to validate_presence_of :name }
    it { expect(subject).to validate_presence_of :workload }
  end

end

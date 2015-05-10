require 'rails_helper'

RSpec.describe Closure do

  it { expect(build(:closure)).to be_valid }

  context 'associations' do
    it { is_expected.to belong_to :user }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
    it { is_expected.to validate_uniqueness_of(:start_date).scoped_to :user_id }
    it { is_expected.to validate_uniqueness_of(:end_date).scoped_to :user_id }
  end

  context 'ordering' do
    let(:user) { create(:user) }
    let(:closure_1) { create(:closure, start_date: 60.days.ago, end_date: 40.days.ago, user: user) }
    let(:closure_2) { create(:closure, start_date: 40.days.ago, end_date: 20.days.ago, user: user) }
    let(:closure_3) { create(:closure, start_date: 20.days.ago, end_date: Date.current, user: user) }

    it { expect(user.closures).to eq [closure_3, closure_2, closure_1] }
  end

  describe '#balance' do
    let!(:user) { create(:user) }
    let!(:closure) { create(:closure, user: user) }

    pending 'when exists days that matches the period' do
      let!(:day_1) { create(:day_record_with_times, reference_date: 3.days.ago, user: user) }
      let!(:day_2) { create(:day_record_with_times, reference_date: 2.days.ago, user: user) }
      let!(:sum_balance) { TimeBalance.new.sum(day_1.balance).sum(day_2.balance) }

      it { expect(closure.balance.hour).to eq sum_balance.hour }
      it { expect(closure.balance.hour).to eq sum_balance.minute }
    end

    context 'when dont exists days that matches the period' do
      it { expect(closure.balance.hour).to eq 0 }
      it { expect(closure.balance.minute).to eq 0 }
    end
  end

end

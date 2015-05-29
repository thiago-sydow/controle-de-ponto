require 'rails_helper'

RSpec.describe Closure do

  it { expect(build(:closure)).to be_valid }

  context 'associations' do
    it { is_expected.to belong_to :account }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
    it { is_expected.to validate_uniqueness_of(:start_date).scoped_to :account_id }
    it { is_expected.to validate_uniqueness_of(:end_date).scoped_to :account_id }
  end

  context 'ordering' do
    let(:account) { create(:account) }
    let(:closure_1) { create(:closure, start_date: 60.days.ago, end_date: 40.days.ago, account: account) }
    let(:closure_2) { create(:closure, start_date: 40.days.ago, end_date: 20.days.ago, account: account) }
    let(:closure_3) { create(:closure, start_date: 20.days.ago, end_date: Date.current, account: account) }

    it { expect(account.closures).to eq [closure_3, closure_2, closure_1] }
  end

  describe '#balance' do
    let!(:account) { create(:account) }
    let!(:closure) { create(:closure, account: account) }

    pending 'when exists days that matches the period' do
      let!(:day_1) { create(:day_record_with_times, reference_date: 3.days.ago, account: account) }
      let!(:day_2) { create(:day_record_with_times, reference_date: 2.days.ago, account: account) }
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

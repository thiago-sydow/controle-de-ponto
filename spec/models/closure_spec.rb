require 'rails_helper'

RSpec.describe Closure do

  context 'associations' do
    it { is_expected.to belong_to :account }
  end

  context 'validations' do
    subject { create(:closure) }
    it { is_expected.to validate_presence_of :start_date }
    it { is_expected.to validate_presence_of :end_date }
    #https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda
    #/matchers/active_record/validate_uniqueness_of_matcher.rb#L26
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

    context 'when dont exists days that matches the period' do
      it { expect(closure.balance.hour).to eq 0 }
      it { expect(closure.balance.minute).to eq 0 }
    end
  end

end

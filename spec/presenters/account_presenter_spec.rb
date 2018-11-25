require 'rails_helper'

describe AccountPresenter do
  let!(:account) { create(:account) }
  let!(:day)  { create(:day_record, account: account) }
  let!(:base_time) { Time.zone.local(1999, 8, 1).change(hour: 0, minute: 0) }
  let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
  let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }
  let!(:account_presenter) { AccountPresenter.new(account) }

  describe '#total_balance' do
    it { expect(account_presenter.total_balance.hour).to eq -4 }
    it { expect(account_presenter.total_balance.minute).to eq -4 }

    context 'when there are closures' do
      let!(:closure) { create(:closure, account: account, end_date: Date.current.tomorrow) }

      it { expect(account_presenter.total_balance.hour).to eq 0 }
      it { expect(account_presenter.total_balance.minute).to eq 0 }
    end
  end

  describe '#total_worked' do
    it { expect(account_presenter.total_worked).to eq (3.hours + 56.minutes) }
  end

  describe '#departure_time' do
    it { expect(account_presenter.departure_time).to eq base_time.change(hour: 16, min: 5) }
  end

  describe '#percentage_worked' do
    it { expect(account_presenter.percentage_worked).to eq 49.2 }
  end

  describe '#next_entrance_time' do
    let!(:new_account) { create(:account) }
    let!(:current_day) { create(:day_record, account: new_account) }
    let!(:presenter) { AccountPresenter.new(new_account) }

    context 'when there is no day record for today' do
      it { expect(presenter.next_entrance_time).to be_nil }
    end

    context 'when there is not time records for today' do
      it { expect(presenter.next_entrance_time).to be_nil }
    end

    context 'when records exists' do
      let!(:time) { create(:time_record, time: base_time.change(hour: 12, min: 0), day_record: current_day) }

      it { expect(presenter.next_entrance_time).to eq base_time.change(hour: 23, min: 0) }
    end
  end

  describe '#total_earned' do
    let!(:self_emp_account) { create(:self_employed_account, hourly_rate: 0) }
    let!(:day) { create(:day_record, account: self_emp_account) }
    let!(:presenter) { AccountPresenter.new(self_emp_account) }

    context 'when hourly_rate is 0' do
      it { expect(presenter.total_earned).to eq 0 }
    end

    context 'when hourly_rate is greater than 0' do
      let!(:time_1) { create(:time_record, time: base_time.change(hour: 12, min: 0), day_record: day) }
      let!(:time_2) { create(:time_record, time: base_time.change(hour: 14, min: 1), day_record: day) }

      before { self_emp_account.hourly_rate = 30; self_emp_account.save! }

      it { expect(presenter.total_earned).to eq 60.50 }
    end

  end

end

require 'rails_helper'

describe DashboardPresenter do
  let!(:user) { create(:user_sequence) }
  let!(:day)  { create(:day_record, user: user) }
  let!(:base_time) { DayRecord::ZERO_HOUR }
  let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
  let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }
  let!(:dashboard) { DashboardPresenter.new(user) }

  describe '.total_balance' do
    it { expect(dashboard.total_balance.hour).to eq -4 }
    it { expect(dashboard.total_balance.minute).to eq -4 }

    context 'when there are closures' do
      let!(:closure) { create(:closure, user: user, end_date: Date.current.tomorrow) }

      it { expect(dashboard.total_balance.hour).to eq 0 }
      it { expect(dashboard.total_balance.minute).to eq 0 }
    end
  end

  describe '.total_worked' do
    it { expect(dashboard.total_worked.hour).to eq 3 }
    it { expect(dashboard.total_worked.min).to eq 56 }
  end

  describe '.departure_time' do
    it { expect(dashboard.departure_time).to eq base_time.change(hour: 16, min: 5) }
  end

  describe '.percentage_worked' do
    it { expect(dashboard.percentage_worked).to eq 49.2 }
  end

end

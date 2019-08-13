require 'rails_helper'

RSpec.describe TimeRecord do

  context 'validations' do
    it { is_expected.to validate_presence_of :time }
    it { is_expected.to belong_to :day_record }
  end

  context 'ordering' do
    let(:day) { create(:day_record) }
    let(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day) }
    let(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day) }
    let(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day) }

    it { expect(day.reload.time_records).to eq [time_1, time_2, time_3] }
  end

  describe '#max_time_count' do
    let!(:account)   { create(:account) }
    let!(:account_1) { create(:account) }
    let!(:account_2) { create(:account) }
    let!(:day_1)  { create(:day_record, account: account_1) }
    let!(:day_2)  { create(:day_record, reference_date: 3.days.ago, account: account_2) }
    let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day_1) }
    let!(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day_2) }
    let!(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day_2) }

    context 'when no day records exists' do
      it { expect(TimeRecord.max_time_count(account.day_records)).to eq 0 }
    end

    context 'when day record exist but no time records' do
      let!(:day)  { create(:day_record, account: account) }

      it { expect(TimeRecord.max_time_count(account.day_records)).to eq 0 }
    end

    context 'when time records exists' do
      it { expect(TimeRecord.max_time_count(account_1.day_records)).to eq 1 }
    end

    context 'when multiple accounts have time records' do
      it { expect(TimeRecord.max_time_count(account_1.day_records)).to eq 1 }
      it { expect(TimeRecord.max_time_count(account_2.day_records)).to eq 2 }
    end
  end
end

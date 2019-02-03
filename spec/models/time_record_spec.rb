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
end

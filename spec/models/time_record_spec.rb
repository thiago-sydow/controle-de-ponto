require 'rails_helper'

RSpec.describe TimeRecord, type: :model do

  it { expect(build(:time_record)).to be_valid }

  context 'validations' do
    it { is_expected.to validate_presence_of :time }
    it { is_expected.to be_embedded_in :day_record }
  end

  context 'ordering' do
    let(:day) { create(:day_record) }
    let(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day) }
    let(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day) }
    let(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day) }

    it { expect(day.time_records).to eq [time_1, time_2, time_3] }
  end

end

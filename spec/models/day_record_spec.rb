require 'rails_helper'

RSpec.describe DayRecord, type: :model do

  it { expect(build(:day_record)).to be_valid }

  context 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.to embed_many :time_records }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :reference_date }
    it { is_expected.to validate_uniqueness_of(:reference_date).scoped_to :user_id }
  end

  context 'ordering' do
    let(:user) { create(:user) }
    let(:day_1) { create(:day_record, reference_date: 3.days.ago, user: user) }
    let(:day_2) { create(:day_record, reference_date: 2.days.ago, user: user) }
    let(:day_3) { create(:day_record, reference_date: 1.days.ago, user: user) }

    it { expect(user.day_records).to eq [day_3, day_2, day_1] }
  end

  describe '#max_time_count_for_user' do
    let!(:user)   { create(:user_sequence) }
    let!(:user_1) { create(:user_sequence) }
    let!(:user_2) { create(:user_sequence) }
    let!(:day_1)  { create(:day_record, user: user_1) }
    let!(:day_2)  { create(:day_record, reference_date: 3.days.ago, user: user_2) }
    let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day_1) }
    let!(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day_2) }
    let!(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day_2) }

    context 'when no day records exists' do
      it { expect(DayRecord.max_time_count_for_user(user)).to eq 0 }
    end

    context 'when day record exist but no time records' do
      let!(:day)  { create(:day_record, user: user) }

      it { expect(DayRecord.max_time_count_for_user(user)).to eq 0 }
    end

    context 'when time records exists' do
      let!(:user)   { create(:user) }
      let!(:day_1)  { create(:day_record, user: user) }
      let!(:day_2)  { create(:day_record, reference_date: 3.days.ago, user: user) }
      let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day_1) }
      let!(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day_2) }
      let!(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day_2) }

      it { expect(DayRecord.max_time_count_for_user(user)).to eq 2 }
    end

    context 'when multiple users have time records' do
      let!(:user_1)   { create(:user_sequence) }
      let!(:user_2)   { create(:user_sequence) }
      let!(:day_1)  { create(:day_record, user: user_1) }
      let!(:day_2)  { create(:day_record, reference_date: 3.days.ago, user: user_2) }
      let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day_1) }
      let!(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day_2) }
      let!(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day_2) }

      it { expect(DayRecord.max_time_count_for_user(user_1)).to eq 1 }
      it { expect(DayRecord.max_time_count_for_user(user_2)).to eq 2 }
    end

  end

  describe 'Time Statistics' do

    describe '#total_worked' do

    end

    describe '#balance' do
      context 'when total_worked is bigger than user workload' do

      end

      context 'when total_worked is smaller than user workload' do

      end
    end

    describe '#positive_balance?' do
      
    end
  end

end

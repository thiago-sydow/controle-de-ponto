require 'rails_helper'

RSpec.describe DayRecord do

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
      it { expect(DayRecord.max_time_count_for_user(user_1)).to eq 1 }
    end

    context 'when multiple users have time records' do
      it { expect(DayRecord.max_time_count_for_user(user_1)).to eq 1 }
      it { expect(DayRecord.max_time_count_for_user(user_2)).to eq 2 }
    end

  end

  describe 'Time Statistics' do
    let!(:user) { create(:user_sequence) }
    let!(:base_time) { DayRecord::ZERO_HOUR }

    describe '#total_worked' do

      context 'without time records' do
        let!(:day)  { create(:day_record, user: user) }

        it { expect(day.total_worked).to eq base_time }
      end

      context 'with time records' do

        context 'when reference_date is not today' do
          let!(:day)  { create(:day_record, reference_date: 3.days.ago, user: user) }
          let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
          let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }
          end

          context 'and the number of time records is odd' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 0), day_record: day) }

            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }
          end
        end

        context 'when reference_date is today' do
          let!(:day)  { create(:day_record, user: user) }
          let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
          let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }
          end

          context 'and the number of time records is odd' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 0), day_record: day) }

            it { expect(day.total_worked).to eq sum_current(base_time.change(hour: 3, min: 56), time_3) }
          end

        end

      end

      context 'when total_worked is called twice' do
        let!(:day)  { create(:day_record, user: user) }

        it 'returns object from memory on second call' do
          expect(day.total_worked).to eq(day.total_worked)
        end

      end

    end

    describe '#balance' do

      context 'when total_worked is called twice' do
        let!(:day)  { create(:day_record, user: user) }

        it 'returns object from memory on second call' do
          expect(day.balance).to eq(day.balance)
        end

      end

    end

  end

  private

  def sum_current(total, record)
    current_sum = Time.diff(record.time, Time.current)
    (total + current_sum[:hour].hours) + current_sum[:minute].minutes
  end

end

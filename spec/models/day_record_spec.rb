require 'rails_helper'

RSpec.describe DayRecord do

  context 'associations' do
    it { is_expected.to belong_to :account }
    it { is_expected.to embed_many :time_records }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :reference_date }
    it { is_expected.to validate_uniqueness_of(:reference_date).scoped_to :account_id }

    context 'when it is only work day' do
      it 'validates the presence of records' do
        allow_any_instance_of(described_class).to receive(:only_work_day?) {
          true
        }
        should validate_presence_of(:time_records)
      end
    end

    context 'when it is not work day' do
      it 'does not validate the presence of records' do
        allow_any_instance_of(described_class).to receive(:only_work_day?) {
          false
        }
        should_not validate_presence_of(:time_records)
      end
    end

  end

  context 'ordering' do
    let(:account) { create(:account) }
    let(:day_1) { create(:day_record, reference_date: 3.days.ago, account: account) }
    let(:day_2) { create(:day_record, reference_date: 2.days.ago, account: account) }
    let(:day_3) { create(:day_record, reference_date: 1.days.ago, account: account) }

    it { expect(account.day_records).to eq [day_3, day_2, day_1] }
  end

  describe '#max_time_count_for_account' do
    let!(:account)   { create(:account_sequence) }
    let!(:account_1) { create(:account_sequence) }
    let!(:account_2) { create(:account_sequence) }
    let!(:day_1)  { create(:day_record, account: account_1) }
    let!(:day_2)  { create(:day_record, reference_date: 3.days.ago, account: account_2) }
    let!(:time_1) { create(:time_record, time: 3.hours.ago, day_record: day_1) }
    let!(:time_2) { create(:time_record, time: 2.hours.ago, day_record: day_2) }
    let!(:time_3) { create(:time_record, time: 1.hours.ago, day_record: day_2) }

    context 'when no day records exists' do
      it { expect(DayRecord.max_time_count_for_account(account)).to eq 0 }
    end

    context 'when day record exist but no time records' do
      let!(:day)  { create(:day_record, account: account) }

      it { expect(DayRecord.max_time_count_for_account(account)).to eq 0 }
    end

    context 'when time records exists' do
      it { expect(DayRecord.max_time_count_for_account(account_1)).to eq 1 }
    end

    context 'when multiple accounts have time records' do
      it { expect(DayRecord.max_time_count_for_account(account_1)).to eq 1 }
      it { expect(DayRecord.max_time_count_for_account(account_2)).to eq 2 }
    end

  end

  describe 'Time Statistics' do
    let!(:account) { create(:account_sequence) }
    let!(:base_time) { ZERO_HOUR }

    describe '#total_worked' do

      context 'without time records' do
        let!(:day)  { create(:day_record, account: account) }

        it { expect(day.total_worked).to eq base_time }
      end

      context 'with time records' do

        context 'when reference_date is not today' do
          let!(:day)  { create(:day_record, reference_date: 3.days.ago, account: account) }
          let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
          let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }

            context 'multiple time records' do
              let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }
              let!(:time_6) { create(:time_record, time: base_time.change(hour: 19, min: 20), day_record: day) }

              it { expect(day.total_worked).to eq base_time.change(hour: 8, min: 10) }
            end

          end

          context 'and the number of time records is odd' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 0), day_record: day) }

            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }

            context 'multiple time records' do
              let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }

              it { expect(day.total_worked).to eq base_time.change(hour: 5, min: 30) }
            end

          end
        end

        context 'when reference_date is today' do
          let!(:day)  { create(:day_record, account: account) }
          let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
          let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq base_time.change(hour: 3, min: 56) }

            context 'multiple time records' do
              let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }
              let!(:time_6) { create(:time_record, time: base_time.change(hour: 19, min: 20), day_record: day) }

              it { expect(day.total_worked).to eq base_time.change(hour: 8, min: 10) }
            end

          end

          context 'and the number of time records is odd' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 0), day_record: day) }

            it { expect(day.total_worked).to eq sum_current(base_time.change(hour: 3, min: 56), time_3) }

            context 'multiple time records' do
              let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }

              it { expect(day.total_worked).to eq sum_current(base_time.change(hour: 5, min: 30), time_5) }
            end

          end

        end

      end

      context 'when total_worked is called twice' do
        let!(:day)  { create(:day_record, account: account) }

        it 'returns object from memory on second call' do
          expect(day.total_worked).to eq(day.total_worked)
        end

      end

    end

    describe '#balance' do
      let!(:day)  { create(:day_record, account: account) }
      let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
      let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

      context 'when is work day' do

        context 'when missed the day' do
          it 'ignore time records created and set to full workload negative' do
            expect_any_instance_of(TimeBalance).to receive(:calculate_balance).with(day.account.workload, base_time)
            day.missed_day = :yes
            day.save
            day.balance
          end
        end

        context 'when not missed the day' do
          it 'calculates the balance normally' do
            expect_any_instance_of(TimeBalance).to receive(:calculate_balance).with(day.account.workload, day.total_worked)
            day.balance
          end
        end

      end

      context 'when is non working day' do

        context 'when missed the day' do
          it 'ignore time records created and clear balance' do
            day.missed_day = :yes
            day.work_day = :no
            day.save
            expect(day.balance.cleared?).to be_truthy
          end
        end

        context 'when not missed the day' do
          it 'ignore time records created and set to full workload negative' do
            expect_any_instance_of(TimeBalance).to receive(:calculate_balance).with(base_time, day.total_worked)
            day.missed_day = :no
            day.work_day = :no
            day.save
            day.balance
          end
        end

      end

      context 'when has medical certificate' do
        it 'reset balance' do
          day.update_attributes(medical_certificate: :yes)
          expect(day.balance.cleared?).to be_truthy
        end
      end

      context 'when account has allowance_time set' do

        it 'reset balance if it is between allowance period' do
          account.update_attributes(allowance_time: ZERO_HOUR.change(hour: 4, min: 4))
          expect(day.balance.cleared?).to be_truthy
        end

        it 'does not reset balance if it is not between allowance period' do
          account.update_attributes(allowance_time: ZERO_HOUR.change(hour: 4, min: 3))
          expect(day.balance.cleared?).to be_falsey
        end
      end

    end

    describe '#forecast_departure_time' do
      let!(:empty_day)  { create(:day_record, reference_date: 4.days.ago, account: account) }

      it { expect(empty_day.forecast_departure_time).to eq base_time }

      context 'when reference_date is not today' do
        let!(:day)  { create(:day_record, reference_date: 3.days.ago, account: account) }
        let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
        let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

        it { expect(day.forecast_departure_time).to eq base_time }
      end

      context 'when reference_date is today' do
        let!(:day)  { create(:day_record, account: account) }
        let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
        let!(:time_2) { create(:time_record, time: base_time.change(hour: 12, min: 1), day_record: day) }

        context 'number of time records is even' do
          it { expect(day.forecast_departure_time).to eq base_time.change(hour: 16, min: 5) }

          context 'multiple time records' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
            let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }

            it { expect(day.forecast_departure_time).to eq base_time.change(hour: 17, min: 5) }
          end

        end

        context 'number of time records is odd' do
          let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 1), day_record: day) }

          it { expect(day.forecast_departure_time).to eq base_time.change(hour: 18, min: 5) }

          context 'multiple time records' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
            let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
            let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }

            it { expect(day.forecast_departure_time).to eq base_time.change(hour: 19, min: 10) }
          end

        end

        context 'account lunch_time config is present' do
          before { account.lunch_time = Time.current.change(hour: 1, min: 0); account.save }

          context 'at most 2 time records' do
            it { expect(day.forecast_departure_time).to eq base_time.change(hour: 17, min: 5) }
          end

          context 'more than 2 time records' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 13, min: 25), day_record: day) }

            it { expect(day.forecast_departure_time).to eq base_time.change(hour: 17, min: 29) }
          end

        end

      end

    end

  end

  describe '#labor_laws_violations' do
    let!(:account) { create(:account_sequence) }
    let!(:base_time) { ZERO_HOUR }
    let!(:day)  { create(:day_record, account: account) }
    let!(:time_1) { create(:time_record, time: base_time.change(hour:  8, min: 5), day_record: day) }
    let!(:time_2) { create(:time_record, time: base_time.change(hour: 19, min: 1), day_record: day) }

    context 'when worked_time exceeds workload above permitted' do
      context 'and config is enabled' do
        it { expect(day.labor_laws_violations[:overtime]).to be_truthy }
      end
      context 'and config is disabled' do
        before { account.warn_overtime = false; account.save }
        it { expect(day.labor_laws_violations[:overtime]).to be_falsey }
      end
    end

    context 'when worked_time exceeds permitted without a rest' do
      context 'and config is enabled' do
        it { expect(day.labor_laws_violations[:straight_hours]).to be_truthy }
      end
      context 'and config is disabled' do
        before { account.warn_straight_hours = false; account.save }
        it { expect(day.labor_laws_violations[:straight_hours]).to be_falsey }
      end
    end
  end

  private

  def sum_current(total, record)
    current_sum = Time.diff(record.time, Time.current)
    (total + current_sum[:hour].hours) + current_sum[:minute].minutes
  end

end

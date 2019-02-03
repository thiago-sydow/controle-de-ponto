require 'rails_helper'

RSpec.describe DayRecord do

  context 'associations' do
    it { is_expected.to belong_to :account }
    it { is_expected.to have_many :time_records }
  end

  context 'validations' do
    subject { create(:day_record) }
    it { is_expected.to validate_presence_of :reference_date }
    #https://github.com/thoughtbot/shoulda-matchers/blob/master/lib/shoulda
    #/matchers/active_record/validate_uniqueness_of_matcher.rb#L26
    it { is_expected.to validate_uniqueness_of(:reference_date).scoped_to :account_id }
  end

  context 'ordering' do
    let(:account) { create(:account) }
    let(:day_1) { create(:day_record, reference_date: 3.days.ago, account: account) }
    let(:day_2) { create(:day_record, reference_date: 2.days.ago, account: account) }
    let(:day_3) { create(:day_record, reference_date: 1.days.ago, account: account) }

    it { expect(account.day_records).to eq [day_3, day_2, day_1] }
  end

  describe '#max_time_count_for_account' do
    let!(:account)   { create(:account) }
    let!(:account_1) { create(:account) }
    let!(:account_2) { create(:account) }
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

  describe 'after_save' do
    let(:acc) { create(:account) }
    let!(:day)  { create(:day_record, account: acc, reference_date: 10.days.ago) }

    context 'touch related closures' do
      let!(:closure_1) { create(:closure, start_date: 20.days.ago, end_date: Date.today, account: acc, updated_at: 1.day.ago) }
      let!(:closure_2) { create(:closure, start_date: 60.days.ago, end_date: 10.days.ago, account: acc, updated_at: 1.day.ago) }
      let!(:closure_3) { create(:closure, start_date: 10.days.ago, end_date: 2.days.ago, account: acc, updated_at: 1.day.ago) }
      let!(:closure_4) { create(:closure, start_date: 5.days.ago, end_date: 1.day.ago, account: acc, updated_at: 1.day.ago) }

      before { day.save }

      it { expect(Closure.find(closure_1.id).updated_at.to_date).to eq Date.today }
      it { expect(Closure.find(closure_3.id).updated_at.to_date).to eq Date.today }
      it { expect(Closure.find(closure_2.id).updated_at.to_date).to eq Date.today }
      it { expect(Closure.find(closure_4.id).updated_at.to_date).to eq Date.yesterday }
    end
  end

  describe 'Time Statistics' do
    let!(:account) { create(:account) }
    let!(:base_time) { Time.zone.local(1999, 8, 1).change(hour: 0, minute: 0) }

    describe '#total_worked' do

      context 'without time records' do
        let!(:day)  { create(:day_record, account: account) }

        it { expect(day.total_worked).to eq 0 }
      end

      context 'with time records' do

        context 'when reference_date is not today' do
          let(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
          let(:time_2) { build(:time_record, time: base_time.change(hour: 12, min: 1)) }
          let!(:day)  { create(:day_record, reference_date: 3.days.ago, account: account, time_records: [time_1, time_2]) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq (3.hours + 56.minutes) }

            context 'multiple time records' do
              let!(:time_3) { build(:time_record, time: base_time.change(hour:  13, min: 1)) }
              let!(:time_4) { build(:time_record, time: base_time.change(hour: 14, min: 35)) }
              let!(:time_5) { build(:time_record, time: base_time.change(hour:  16, min: 40)) }
              let!(:time_6) { build(:time_record, time: base_time.change(hour: 19, min: 20)) }

              before do
                day.time_records += [time_3, time_4, time_5, time_6]
                day.save
              end

              it { expect(day.total_worked).to eq (8.hours + 10.minutes) }
            end
          end

          context 'and the number of time records is odd' do
            let!(:time_3) { create(:time_record, time: base_time.change(hour: 14, min: 0)) }

            before do
              day.time_records += [time_3]
              day.save
            end

            it { expect(day.total_worked).to eq (3.hours + 56.minutes) }

            context 'multiple time records' do
              let!(:time_3) { create(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { create(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { create(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }

              before do
                day.time_records += [time_3, time_4, time_5]
                day.save
              end


              it { expect(day.total_worked).to eq (5.hours + 30.minutes) }
            end

          end
        end

        context 'when reference_date is today' do
          let(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
          let(:time_2) { build(:time_record, time: base_time.change(hour: 12, min: 1)) }
          let!(:day)  { create(:day_record, account: account, time_records: [time_1, time_2]) }

          context 'and the number of time records is even' do
            it { expect(day.total_worked).to eq (3.hours + 56.minutes) }

            context 'multiple time records' do
              let!(:time_3) { build(:time_record, time: base_time.change(hour:  13, min: 1)) }
              let!(:time_4) { build(:time_record, time: base_time.change(hour: 14, min: 35)) }
              let!(:time_5) { build(:time_record, time: base_time.change(hour:  16, min: 40)) }
              let!(:time_6) { build(:time_record, time: base_time.change(hour: 19, min: 20)) }

              before do
                day.time_records += [time_3, time_4, time_5, time_6]
                day.save
              end

              it { expect(day.total_worked).to eq (8.hours + 10.minutes) }
            end

          end

          context 'and the number of time records is odd' do
            let!(:time_3) { build(:time_record, time: base_time.change(hour: 14, min: 0)) }

            before do
              day.time_records += [time_3]
              day.save
            end

            it { expect(day.total_worked).to eq sum_current((3.hours + 56.minutes), time_3) }

            context 'multiple time records' do
              let!(:time_3) { build(:time_record, time: base_time.change(hour:  13, min: 1), day_record: day) }
              let!(:time_4) { build(:time_record, time: base_time.change(hour: 14, min: 35), day_record: day) }
              let!(:time_5) { build(:time_record, time: base_time.change(hour:  16, min: 40), day_record: day) }

              before do
                day.time_records += [time_3, time_4, time_5]
                day.save
              end

              it { expect(day.total_worked).to eq sum_current((5.hours + 30.minutes), time_5) }
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
      let!(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
      let!(:time_2) { build(:time_record, time: base_time.change(hour: 12, min: 1)) }
      let!(:day)  { create(:day_record, account: account, time_records: [time_1, time_2]) }

      context 'when is work day' do
        context 'when missed the day' do
          it 'ignore time records created and set to full workload negative' do
            expect_any_instance_of(TimeBalance).to receive(:calculate_balance).with(day.account.workload, 0)
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
            expect_any_instance_of(TimeBalance).to receive(:calculate_balance).with(0, day.total_worked)
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
          account.update_attributes(allowance_time: (4.hours + 4.minutes))
          expect(day.balance.cleared?).to be_truthy
        end

        it 'does not reset balance if it is not between allowance period' do
          account.update_attributes(allowance_time: (4.hours + 3.minutes))
          expect(day.balance.cleared?).to be_falsey
        end
      end
    end

    describe '#forecast_departure_time' do
      let!(:empty_day)  { create(:day_record, reference_date: 4.days.ago, account: account) }

      it { expect(empty_day.forecast_departure_time).to eq 0 }

      context 'when reference_date is not today' do
        let!(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
        let!(:time_2) { build(:time_record, time: base_time.change(hour: 12, min: 1)) }
        let!(:day)  { create(:day_record, reference_date: 3.days.ago, account: account, time_records: [time_1, time_2]) }

        it { expect(day.forecast_departure_time).to eq 0 }
      end

      context 'when reference_date is today' do
        let!(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
        let!(:time_2) { build(:time_record, time: base_time.change(hour: 12, min: 1)) }
        let!(:day)  { create(:day_record, account: account, time_records: [time_1, time_2]) }

        context 'number of time records is even' do
          it { expect(day.forecast_departure_time).to eq (base_time + (16.hours + 5.minutes)) }

          context 'multiple time records' do
            let!(:time_3) { build(:time_record, time: base_time.change(hour:  13, min: 1)) }
            let!(:time_4) { build(:time_record, time: base_time.change(hour: 14, min: 35)) }

            before do
              day.time_records += [time_3, time_4]
              day.save
            end

            it { expect(day.forecast_departure_time).to eq (base_time + (17.hours + 5.minutes)) }
          end
        end

        context 'number of time records is odd' do
          let(:time_3) { build(:time_record, time: base_time.change(hour: 14, min: 1)) }

          before do
            day.time_records += [time_3]
            day.save
          end

          it { expect(day.forecast_departure_time).to eq (base_time + (18.hours + 5.minutes)) }

          context 'multiple time records' do
            let!(:time_3) { build(:time_record, time: base_time.change(hour:  13, min: 1)) }
            let!(:time_4) { build(:time_record, time: base_time.change(hour: 14, min: 35)) }
            let!(:time_5) { build(:time_record, time: base_time.change(hour:  16, min: 40)) }

            before do
              day.time_records += [time_3, time_4, time_5]
              day.save
            end

            it { expect(day.forecast_departure_time).to eq (base_time + (19.hours + 10.minutes)) }
          end
        end

        context 'account lunch_time config is present' do
          before { account.lunch_time = 1.hour; account.save }

          context 'at most 2 time records' do
            it { expect(day.forecast_departure_time).to eq (base_time + (17.hours + 5.minutes)) }
          end

          context 'more than 2 time records' do
            let!(:time_3) { build(:time_record, time: base_time.change(hour: 13, min: 25)) }

            before do
              day.time_records += [time_3]
              day.save
            end

            it { expect(day.forecast_departure_time).to eq (base_time + (17.hours + 29.minutes)) }
          end
        end
      end
    end
  end

  describe '#labor_laws_violations' do
    let(:account) { create(:account) }
    let(:base_time) { Time.zone.local(1999, 8, 1).change(hour: 0, minute: 0) }
    let(:time_1) { build(:time_record, time: base_time.change(hour:  8, min: 5)) }
    let(:time_2) { build(:time_record, time: base_time.change(hour: 19, min: 1)) }
    let(:day)  { create(:day_record, account: account, time_records: [time_1, time_2]) }

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

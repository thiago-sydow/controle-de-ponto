require 'rails_helper'

RSpec.describe Record, type: :model do

  let!(:user) { build(:user) }

  let!(:base_time) { Time.current.yesterday.change(hour: 8) }
  let!(:record_1) { create(:record, time: base_time, user: user, ) }
  let!(:record_2) { create(:record, time: base_time + 4.hour, user: user) }
  let!(:record_3) { create(:record, time: base_time + 5.hour, user: user) }
  let!(:record_4) { create(:record, time: base_time + 9.hour, user: user) }
  let!(:records)  { [record_1, record_2, record_3, record_4] }

  it { expect(build(:record)).to be_valid }
  it { expect(subject).to validate_presence_of :time }
  it { expect(subject).to belong_to :user }
  it { expect(build(:record, user: nil)).not_to be_valid }

  context 'ordered records' do
    it { expect(Record.all.to_a).to eq [record_1, record_2, record_3, record_4] }
  end

  context 'calculate worked hours' do

    context 'when there are no records' do
      it { expect(Record.worked_hours([])).to eq Time.current.midnight }
    end

    context 'when it is not today' do
      it { expect(Record.worked_hours([record_1])).to  eq base_time.midnight }
      it { expect(Record.worked_hours(records[0..1])).to eq base_time.change(hour: 4) }
      it { expect(Record.worked_hours(records[0..2])).to eq base_time.change(hour: 4) }
      it { expect(Record.worked_hours(records)).to eq base_time.change(hour: 8) }
    end

    context 'when it is today' do
      let!(:base_time) { Time.current.change(hour: 8) }

      it { expect(Record.worked_hours([record_1])).to    eq(sum_current(base_time.midnight, record_1)) }
      it { expect(Record.worked_hours(records[0..1])).to eq(base_time.change(hour: 4)) }
      it { expect(Record.worked_hours(records[0..2])).to eq(sum_current(base_time.change(hour: 4), record_3)) }
      it { expect(Record.worked_hours(records)).to eq base_time.change(hour: 8) }
    end

  end

  context 'calculate exit time' do

    context 'when there are no records' do
      it { expect(Record.preview_exit_time([])).to eq (Time.current.midnight) }
    end

    context 'when there are records' do
      let!(:base_time) { Time.current.change(hour: 8) }

      context 'and rest ones' do
        it { expect(Record.preview_exit_time(records[0..2])).to eq(Time.current.change(hour: 17)) }
      end

      context 'but not rest ones' do
        it { expect(Record.preview_exit_time([record_1])).to eq(Time.current.change(hour: 16)) }
      end

    end

  end

  private

  def sum_current(total, record)
    current_sum = Time.diff(record.time, Time.current)
    (total + current_sum[:hour].hours) + current_sum[:minute].minutes
  end

end

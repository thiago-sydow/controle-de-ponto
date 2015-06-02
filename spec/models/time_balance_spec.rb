require 'rails_helper'

RSpec.describe TimeBalance do

  let(:balance) { TimeBalance.new }

  describe '#positive?' do
    context 'when time_2 is greater' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(balance.positive?).to be_truthy }
    end

    context 'when time_1 is greater' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(balance.positive?).to be_falsey }
    end

    context 'when are equal' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(balance.positive?).to be_falsey }
    end
  end

  describe '#cleared?' do
    context 'when time_2 is greater' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(balance.cleared?).to be_falsey }
    end

    context 'when time_1 is greater' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(balance.cleared?).to be_falsey }
    end

    context 'when are equal' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(balance.cleared?).to be_truthy }
    end
  end

  describe '#negative?' do
    context 'when time_2 is greater' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(balance.negative?).to be_falsey }
    end

    context 'when time_1 is greater' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(balance.negative?).to be_truthy }
    end

    context 'when are equal' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(balance.negative?).to be_falsey }
    end
  end

  describe '#to_s' do
    context 'when time_2 time is greater' do
      let!(:balance_1) { TimeBalance.new }

      before do
        balance.calculate_balance(3.hours.ago, 2.hours.ago + 1.minute)
        balance_1.calculate_balance(2.hours.ago, 8.hours.ago + 75.minutes)
      end

      it { expect(balance.to_s).to eq '01:01' }
      it { expect(balance_1.to_s).to eq '04:45' }
    end

    context 'when time_1 is greater' do
      let!(:balance_1) { TimeBalance.new }

      before do
        balance.calculate_balance(2.hours.ago, 3.hours.ago + 1.minute)
        balance_1.calculate_balance(2.hours.ago, 6.hours.ago + 17.minutes)
      end

      it { expect(balance.to_s).to eq '00:59' }
      it { expect(balance_1.to_s).to eq '03:43' }
    end

    context 'when are equal' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(balance.to_s).to eq '00:00' }
    end

  end

  describe '#sum' do
    let!(:base_hour) { Time.current.change(hour: 8, min: 0) }
    context 'negative balances' do
      let!(:balance_1) { TimeBalance.new }

      context 'both are negatives' do

        before do
          balance.calculate_balance(base_hour + 8.hours, base_hour + 3.hours)
          balance_1.calculate_balance(base_hour + 3.hours, base_hour + 2.hours)
        end

        it { expect(balance.sum(balance_1).hour).to eq -6 }
        it { expect(balance.sum(balance_1).minute).to eq 0 }
      end

      context 'when other is negative' do

        before do
          balance.calculate_balance(base_hour + 1.hour, base_hour + 2.hours)
          balance_1.calculate_balance(base_hour + 6.hours, base_hour + 2.hours)
        end

        it { expect(balance.sum(balance_1).hour).to eq -3 }
        it { expect(balance.sum(balance_1).minute).to eq 0 }
      end

      context 'when other is cleared' do

        before do
          balance.calculate_balance(base_hour + 2.hours, base_hour + 1.hour)
          balance_1.calculate_balance(base_hour + 2.hours, base_hour + 2.hours)
        end

        it { expect(balance.sum(balance_1).hour).to eq -1 }
      end

      context 'many balances' do
        let!(:balance_2) { TimeBalance.new }
        let!(:balance_3) { TimeBalance.new }
        let!(:balance_4) { TimeBalance.new }

        before do
          
          balance.calculate_balance(base_hour + 10.minutes, base_hour + 1.hour)
          balance_1.calculate_balance(base_hour - 2.hours, base_hour - 3.hours + 29.minutes)
          balance_2.calculate_balance(base_hour +  45.minutes, base_hour + 5)
          balance_3.calculate_balance(base_hour + 6.hours, base_hour + 3.hours - 16.minutes)
          balance_4.calculate_balance(base_hour - 5.hours +  59.minutes, base_hour + 3.hours)

          balance.sum(balance_1).sum(balance_2).sum(balance_3).sum(balance_4)
        end

        it { expect(balance.hour).to eq 3 }
        it { expect(balance.minute).to eq 19 }
      end

    end

  end

end

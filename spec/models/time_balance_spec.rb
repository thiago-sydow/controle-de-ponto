require 'rails_helper'

RSpec.describe TimeBalance do

  let!(:base_time) { TimeBalance::BASE_TIME }

  describe '#positive?' do
    context 'when worked time is greater' do
      let(:balance) { TimeBalance.new(3.hours.ago, 2.hours.ago) }

      it { expect(balance.positive?).to be_truthy }
    end

    context 'when workload is greater' do
      let(:balance) { TimeBalance.new(2.hours.ago, 3.hours.ago) }

      it { expect(balance.positive?).to be_falsey }
    end

    context 'when are equal' do
      let(:balance) { TimeBalance.new(2.hours.ago, 2.hours.ago) }

      it { expect(balance.positive?).to be_falsey }
    end
  end

  describe '#cleared?' do
    context 'when worked time is greater' do
      let(:balance) { TimeBalance.new(3.hours.ago, 2.hours.ago) }

      it { expect(balance.cleared?).to be_falsey }
    end

    context 'when workload is greater' do
      let(:balance) { TimeBalance.new(2.hours.ago, 3.hours.ago) }

      it { expect(balance.cleared?).to be_falsey }
    end

    context 'when are equal' do
      let(:balance) { TimeBalance.new(2.hours.ago, 2.hours.ago) }

      it { expect(balance.cleared?).to be_truthy }
    end
  end

  describe '#to_s' do
    context 'when worked time is greater' do
      let(:balance) { TimeBalance.new(3.hours.ago, 2.hours.ago + 1.minute) }
      let(:balance_1) { TimeBalance.new(2.hours.ago, 8.hours.ago + 75.minutes) }

      it { expect(balance.to_s).to eq '01:01' }
      it { expect(balance_1.to_s).to eq '04:45' }
    end

    context 'when workload is greater' do
      let(:balance) { TimeBalance.new(2.hours.ago, 3.hours.ago + 1.minute) }
      let(:balance_1) { TimeBalance.new(2.hours.ago, 6.hours.ago + 17.minute) }

      it { expect(balance.to_s).to eq '00:59' }
      it { expect(balance_1.to_s).to eq '03:43' }
    end

    context 'when are equal' do
      let(:balance) { TimeBalance.new(2.hours.ago, 2.hours.ago) }

      it { expect(balance.to_s).to eq '00:00' }
    end

  end

end

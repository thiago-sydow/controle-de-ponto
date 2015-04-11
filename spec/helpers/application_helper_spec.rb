require 'rails_helper'

describe ApplicationHelper do

  describe '.get_time_label_from_number' do

    context 'when number is even' do
      it { expect(helper.get_time_label_from_number(0)).to eq 'Entrada 1' }
      it { expect(helper.get_time_label_from_number(2)).to eq 'Entrada 2' }
    end

    context 'when number is odd' do
      it { expect(helper.get_time_label_from_number(1)).to eq 'Saída 1' }
      it { expect(helper.get_time_label_from_number(3)).to eq 'Saída 2' }
    end
  end

  describe '.get_icon_and_text_color_balance' do
    context 'when balance is positive' do
      let(:balance) { TimeBalance.new(3.hours.ago, 2.hours.ago) }

      it { expect(helper.get_text_color_balance(balance)).to eq 'text-success' }
      it { expect(helper.get_icon_balance(balance)).to eq 'fa-plus-circle' }
    end

    context 'when balance is cleared' do
      let(:balance) { TimeBalance.new(2.hours.ago, 2.hours.ago) }

      it { expect(helper.get_text_color_balance(balance)).to eq 'text-success' }
      it { expect(helper.get_icon_balance(balance)).to eq 'fa-check-circle' }
    end

    context 'when balance is negative' do
      let(:balance) { TimeBalance.new(2.hours.ago, 3.hours.ago) }

      it { expect(helper.get_text_color_balance(balance)).to eq 'text-danger' }
      it { expect(helper.get_icon_balance(balance)).to eq 'fa-minus-circle' }
    end

  end

  describe '#flash_class' do
    context 'success' do
      it { expect(flash_class('success')).to eq 'success' }
    end

    context 'error' do
      it { expect(flash_class('error')).to eq 'danger' }
    end

    context 'notice' do
      it { expect(flash_class('notice')).to eq 'info' }
    end

    context 'alert' do
      it { expect(flash_class('alert')).to eq 'warning' }
    end
  end

  describe 'flash_icon' do
    context 'success' do
      it { expect(flash_icon('success')).to eq 'fa-check' }
    end

    context 'error' do
      it { expect(flash_icon('error')).to eq 'fa-ban' }
    end

    context 'notice' do
      it { expect(flash_icon('notice')).to eq 'fa-info' }
    end

    context 'alert' do
      it { expect(flash_icon('alert')).to eq 'fa-exclamation-triangle' }
    end
  end

end

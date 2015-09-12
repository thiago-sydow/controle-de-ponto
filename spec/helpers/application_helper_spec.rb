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

  describe '.get_color_balance' do
    let(:balance) { TimeBalance.new }

    context 'when balance is positive' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(helper.get_color_balance(balance)).to eq 'success' }
    end

    context 'when balance is cleared' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(helper.get_color_balance(balance)).to eq 'success' }
    end

    context 'when balance is negative' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(helper.get_color_balance(balance)).to eq 'danger' }
    end

  end

  describe '.get_icon_balance' do
    let(:balance) { TimeBalance.new }

    context 'when balance is positive' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(helper.get_icon_balance(balance)).to eq 'fa-plus-circle' }
    end

    context 'when balance is cleared' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(helper.get_icon_balance(balance)).to eq 'fa-check-circle' }
    end

    context 'when balance is negative' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(helper.get_icon_balance(balance)).to eq 'fa-minus-circle' }
    end

  end

  describe '.get_dashboard_color' do
    let(:balance) { TimeBalance.new }

    context 'when balance is positive' do
      before { balance.calculate_balance(3.hours.ago, 2.hours.ago) }

      it { expect(helper.get_dashboard_color(balance)).to eq 'infobox-green' }
    end

    context 'when balance is cleared' do
      before { balance.calculate_balance(2.hours.ago, 2.hours.ago) }

      it { expect(helper.get_dashboard_color(balance)).to eq 'infobox-green' }
    end

    context 'when balance is negative' do
      before { balance.calculate_balance(2.hours.ago, 3.hours.ago) }

      it { expect(helper.get_dashboard_color(balance)).to eq 'infobox-red' }
    end

  end

  describe '.flash_class' do
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

  describe '.flash_icon' do
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

  describe '.display_labor_laws_violations' do
    let!(:user) { create(:user) }
    let!(:account) { create(:account, user: user) }
    let!(:day) { create(:day_record, account: account) }

    context 'overtime violation' do
      let(:violations) { {overtime: true, straight_hours: false} }
      let(:expected) { '<a class="balance-info" tabindex="0" role="button" data-toggle="popover" data-trigger="focus" data-content="Você ultrapassou o limite de 2 horas extras diárias." title="Art. 49 CLT">  <i class="ace-icon fa fa-exclamation-triangle orange bigger-120"></i></a>' }

      before { allow(day).to receive(:labor_laws_violations).and_return(violations) }

      it { expect(display_labor_laws_violations(day, account).to_str.tr("\r\n", "")).to eq expected }
    end

    context 'straight_hours violation' do
      let(:violations) { {overtime: false, straight_hours: true} }
      let(:expected) { '<a class="balance-info" tabindex="0" role="button" data-toggle="popover" data-trigger="focus" data-content="Você trabalhou mais que 6 horas consecutivas sem um período de descanso." title="Art. 71 CLT">  <i class="ace-icon fa fa-exclamation-triangle orange bigger-120"></i></a>' }

      before { allow(day).to receive(:labor_laws_violations).and_return(violations) }

      it { expect(display_labor_laws_violations(day, account).to_str.tr("\r\n", "")).to eq expected }
    end
  end

  describe '.save_and_add_text' do
    context 'when it is a new record' do
      let(:expected) { "#{I18n.t('helpers.submit.create', model: DayRecord.model_name.human)} #{I18n.t('helpers.submit.and_add')}" }

      it { expect(save_and_add_text(DayRecord.new)).to eq expected }
    end

    context 'when it is a existent record' do
      let!(:user) { create(:user) }
      let!(:day) { create(:day_record, account: user.account) }
      let(:expected) { "#{I18n.t('helpers.submit.update', model: DayRecord.model_name.human)} #{I18n.t('helpers.submit.and_add')}" }

      it { expect(save_and_add_text(day)).to eq expected }
    end
  end

end

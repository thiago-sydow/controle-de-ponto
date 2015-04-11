require 'rails_helper'

describe DeviseHelper do

  describe ".devise_alert_messages!" do
    context "without errors" do
      it { expect(helper.devise_alert_messages!).to eq '' }
    end

    context "with errors" do
      before { allow(helper).to receive(:alert).and_return I18n.t('devise.failure.invalid') }

      it { expect(helper.devise_alert_messages!).to include I18n.t('devise.failure.invalid') }
    end

  end

end

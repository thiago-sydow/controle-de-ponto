require 'rails_helper'

RSpec.describe SelfEmployedAccount, type: :model do
  context 'validations' do
    it { is_expected.to allow_value(9.99, 0.0).for(:hourly_rate) }
    it { is_expected.not_to allow_value('', nil).for(:hourly_rate) }
  end
end

require 'rails_helper'

RSpec.describe User do

  context 'associations' do
    it { is_expected.to have_many :accounts }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :last_name }
    it { is_expected.to validate_presence_of :birthday }
    it { is_expected.to validate_presence_of :gender }
  end

  context 'authenticate user' do
    let(:user) { create(:user) }

    it { expect(user.valid_password?('password')).to be }
    it { expect(user.valid_password?('falsepassword')).not_to be }
  end

  context 'callbacks' do
    context '.after_create' do
      let!(:user) { create(:user) }

      it { expect(user.accounts.size).to eq 1 }
      it { expect(user.current_account).not_to be_nil }
    end

    context '.after_save' do
      let!(:user) { create(:user) }

      before do
        user.accounts.create({ name: 'Emprego CLT', type: 'CltWorkerAccount' })
        user.accounts = [user.accounts.first]
        user.save
      end

      it { expect(user.accounts.size).to eq 1 }
      it { expect(user.current_account).not_to be_nil }
    end
  end

  context '#change_current_account_to' do
    let!(:user) { create(:user) }
    let!(:last_update) { user.current_account.updated_at }

    context 'when user have only one account' do
      before { user.change_current_account_to(user.current_account.id) }

      it { expect(user.current_account.updated_at).to eq last_update }
    end

    context 'when user have more accounts' do
      let!(:new_account) { create(:account_sequence, user: user) }

      before { user.change_current_account_to(new_account.id) }

      it { expect(user.current_account).to eq new_account }
    end
  end

  context '#current_account' do
    let!(:user) { create(:user) }
    before { user.accounts.destroy_all }

    context 'when not have account, should be create default account' do
      it { expect(user.current_account).not_to be_nil }
    end
  end
end

require 'rails_helper'

describe AccountsController do
  let!(:user) { create(:user) }
  let!(:account) { user.current_account }

  describe '#change_current' do
    context 'when user is logged in' do
      login_user

      context 'and account id does not exist' do
        before { patch :change_current, params: { id: 999999 } }

        it { expect(user.current_account).to eq account }
      end

      context 'and have only one account' do
        before { patch :change_current, params: { id: account.id } }

        it { expect(user.current_account).to eq account }
      end

      context 'and have more than one account' do
        let!(:new_account) { create(:account, user: user) }

        before { patch :change_current, params: { id: new_account.id } }

        it { expect(user.reload.current_account).to eq new_account }

        context 'and account id does not exist' do
          before { patch :change_current, params: { id: 99999 } }

          it { expect(response).to be_not_found }
        end
      end
    end

    context 'when user is not logged in' do
      before { patch :change_current, params: { id: account.id } }

      it_behaves_like 'a not authorized request'
    end
  end
end

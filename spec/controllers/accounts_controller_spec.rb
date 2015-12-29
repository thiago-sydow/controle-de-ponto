require 'rails_helper'

describe AccountsController do

  let!(:user) { create(:user_sequence) }
  let!(:account) { user.current_account }

  describe '#change_current' do

    context 'when user is logged in' do
      login_user

      context 'and account id does not exist' do
        before { patch :change_current, id: 999999 }

        it { expect(user.current_account).to eq account }
      end

      context 'and have only one account' do
        before { patch :change_current, id: account.id }

        it { expect(user.current_account).to eq account }
      end

      context 'and have more than one account' do
        let!(:new_account) { create(:account_sequence, user: user) }

        before { patch :change_current, id: new_account.id }

        it { expect(user.reload.current_account).to eq new_account }

        context 'and account id does not exist' do
          it { expect { patch :change_current, id: 99999 }.to raise_error(ActiveRecord::RecordNotFound) }
        end
      end
    end

    context 'when user is not logged in' do
      before { patch :change_current, id: account.id }

      it_behaves_like 'a not authorized request'
    end
  end

end

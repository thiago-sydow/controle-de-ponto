require 'rails_helper'

describe ClosuresController do
  let!(:user) { create(:user) }
  let!(:account) { user.current_account }

  describe '#index' do
    let!(:closure) { create(:closure, account: account) }

    context 'when user is logged in' do
      login_user

      before { get :index }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:closures)).to eq([closure]) }
      it { expect(response).to render_template(:index) }
    end

    context 'when user is not logged in' do
      before { get :index }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#edit' do
    let(:closure) { create(:closure, account: account) }

    context 'when user is logged in' do
      login_user

      before { get :edit, params: { id: closure.id } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:closure)).to eq(closure) }
      it { expect(response).to render_template(:edit) }

      context ' and the record is not from the user' do
        let(:other_closure) { create(:closure) }

        before { get :edit, params: { id: other_closure.id } }

        it { expect(response).to be_not_found }
      end
    end

    context 'when user is not logged in' do
      before { get :edit, params: { id: closure.id } }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#new' do
    context 'when user is logged in' do
      login_user

      before { get :new }

      subject(:assigned) { assigns(:closure) }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:new) }
      it { expect(assigned).to be_a_new(Closure) }
      it { expect(assigned.start_date).to eq Date.current - 3.months }
      it { expect(assigned.end_date).to eq Date.current }
    end

    context 'when user is not logged in' do
      before { get :new }
      it_behaves_like 'a not authorized request'
    end

  end

  describe '#create' do
    let!(:attrs) { attributes_for(:closure, account: account) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { post :create, params: { closure: attrs } }

        it { expect(response).to redirect_to closures_path }
        it { expect(flash[:success]).not_to be_nil }
      end

      context ' and parameters are wrong' do
        it { expect { post(:create) }.to raise_error(ActionController::ParameterMissing) }
      end

      context ' and an error occured while creating' do
        before do
          allow_any_instance_of(Closure).to receive(:save).and_return(false)
          post :create, params: { closure: attrs }
        end

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(account.closures.count).to eq(0) }
      end

    end

    context 'when user is not logged in' do
      before { post :create, params: { closure: attrs } }
      it_behaves_like 'a not authorized request'
    end

  end

  context '#update' do
    let!(:closure) { create(:closure, account: account) }
    let(:attrs) { { end_date: Date.current.yesterday } }

    context 'when user is logged in' do

      login_user

      context ' and parameters are right' do
        before { patch :update, params: { id: closure.id, closure: attrs } }

        it { is_expected.to redirect_to closures_path }
        it { expect(flash[:success]).not_to be_nil }
        it { expect(closure.reload.end_date).to eq Date.current.yesterday }
      end

      context ' and parameters are wrong' do
        it { expect { patch(:update, params: { id: closure.id }) }.to raise_error(ActionController::ParameterMissing) }
      end

      context ' and an error occured while updating' do
        before do
          allow_any_instance_of(Closure).to receive(:update).and_return(false)
          patch :update, params: { id: closure.id, closure: attrs }
        end

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).not_to be_nil }
      end

      context ' and the record is not from the user' do
        let(:other_closure) { create(:closure) }

        before { patch :update, params: { id: other_closure.id, closure: attrs } }

        it { expect(response).to be_not_found }
      end
    end

    context 'when user is not logged in' do
      before { patch :update, params: { id: closure.id, closure: attrs } }
      it_behaves_like 'a not authorized request'
    end
  end

  describe '#destroy' do
    let!(:closure) { create(:closure, account: account) }
    let(:find_closure) { Closure.find(closure.id) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { delete :destroy, params: { id: closure.id } }

        it { is_expected.to redirect_to closures_path }
        it { expect(flash[:success]).not_to be_nil }
      end

      context ' and parameters are wrong' do
        before { delete :destroy, params: { id: '11111' } }

        it { expect(response).to be_not_found }
      end

      context ' and an error occured while updating' do
        before do
          allow_any_instance_of(Closure).to receive(:destroy).and_return(closure)
          allow_any_instance_of(Closure).to receive(:destroyed?).and_return(false)
          delete :destroy, params: { id: closure.id }
        end

        it { expect(response).to redirect_to closures_path }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(find_closure).to eq(closure) }
      end
    end

    context 'when user is not logged in' do
      before { delete :destroy, params: { id: closure.id } }
      it_behaves_like 'a not authorized request'
    end
  end
end

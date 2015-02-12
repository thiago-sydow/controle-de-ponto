require 'rails_helper'

RSpec.describe RecordsController, type: :controller do

  let!(:user) { create(:user) }

  context '#index' do
    context 'when user is logged in' do
      login_user

      let(:record) { create(:record, user: user) }
      before { get :index }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:records)).to eq([record]) }
      it { expect(assigns(:total_time)).not_to be_nil } 
      it { expect(response).to render_template(:index) }
    end

    context 'when user is not logged in' do
      before { get :index }

      it { expect(response).to have_http_status(:found) }
      it { expect(assigns(:records)).to be_nil }
      it { expect(response).to redirect_to('/users/sign_in') }
    end

  end

  context '#edit' do
    let(:record) { create(:record, user: user) }

    context 'when user is logged in' do
      login_user

      before { get :edit, id: record.id }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:record)).to eq(record) }
      it { expect(response).to render_template(:edit) }
    end

    context 'when user is not logged in' do

      before { get :edit, id: record.id }

      it { expect(response).to have_http_status(:found) }
      it { expect(assigns(:record)).to be_nil }
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end

  context '#new' do

    context 'when user is logged in' do
      login_user

      before { get :new }

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:record)).to be_a_new(Record) }
      it { expect(response).to render_template(:new) }
    end

    context 'when user is not logged in' do

      before { get :new }

      it { expect(response).to have_http_status(:found) }
      it { expect(assigns(:record)).to be_nil }
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end

  context '#create' do
    let(:record) { attributes_for(:record) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { post :create, record: record }

        it { expect(response).to redirect_to records_path }
        it { expect(flash[:success]).not_to be_nil }
      end

      context ' and parameters are wrong' do
        it { expect { post(:create) }.to raise_error(ActionController::ParameterMissing) }
      end

      context ' and an error occured while creating' do
        before do
          allow_any_instance_of(Record).to receive(:save).and_return(false)
          post :create, record: record
        end

        it { expect(response).to render_template(:new) }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(Record.count).to eq(0) }
      end

    end

    context 'when user is not logged in' do

      before { post :create, record: record }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end

  context '#update' do
    let!(:record)        { create(:record, user: user) }
    let!(:updated_time)  { record.time + 1.hour }
    let(:updated_record) { Record.find(record.id) }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        before { patch :update, id: record.id, record: { time: updated_time } }

        it { expect(subject).to redirect_to records_path }
        it { expect(flash[:success]).not_to be_nil }
        it { expect(updated_record.time).to be_same_second_as(updated_time) }
      end

      context ' and parameters are wrong' do
        it { expect { patch(:update, id: record.id) }.to raise_error(ActionController::ParameterMissing) }
        it { expect(updated_record).to eq(record) }
      end

      context ' and an error occured while updating' do
        before do
          allow_any_instance_of(Record).to receive(:update_attributes).and_return(false)
          patch :update, id: record.id, record: { time: updated_time }
        end

        it { expect(response).to render_template(:edit) }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(updated_record).to eq(record) }
      end

    end

    context 'when user is not logged in' do

      before { patch :update, id: record.id, record: { time: updated_time } }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end

  context '#destroy' do
    let(:record_db) { Record.where(id: record.id).first }

    context 'when user is logged in' do
      login_user

      context ' and parameters are right' do
        let(:record)   { create(:record, user: user) }
        before { delete :destroy, id: record.id }

        it { expect(subject).to redirect_to records_path }
        it { expect(flash[:success]).not_to be_nil }
        it { expect(record_db).to be_nil }
      end

      context ' and parameters are wrong' do
        let(:record)   { create(:record, user: user) }

        it { expect(record_db).to eq(record) }
      end

      context ' and an error occured while updating' do
        let(:record) { create(:record, user: user) }

        before do
          allow_any_instance_of(Record).to receive(:destroy).and_return(record)
          allow_any_instance_of(Record).to receive(:destroyed?).and_return(false)
          delete :destroy, id: record.id
        end

        it { expect(response).to redirect_to records_path }
        it { expect(flash[:error]).not_to be_nil }
        it { expect(record_db).to eq(record) }
      end

    end

    context 'when user is not logged in' do
      let(:record)   { create(:record, user: user) }

      before { delete :destroy, id: record.id }

      it { expect(response).to have_http_status(:found) }
      it { expect(response).to redirect_to('/users/sign_in') }
    end
  end

end

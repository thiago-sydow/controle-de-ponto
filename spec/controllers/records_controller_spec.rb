require 'rails_helper'

RSpec.describe RecordsController, type: :controller do

  context '#index' do

    context 'when user is logged in' do
      login_user

      let(:record) { create(:record, user: @user) }

      before do
        get :index
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(assigns(:records)).to eq([record]) }
      it { expect(response).to render_template(:index) }
    end

    context 'when user is not logged in' do
      before do
        get :index
      end

      it { expect(response).to have_http_status(:found) }
      it { expect(assigns(:records)).to be_nil }
      it { expect(response).to redirect_to('/users/sign_in') }
    end

  end

  context '#edit' do
    
  end

end

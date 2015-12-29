require 'rails_helper'

describe SiteController do

  describe '#index' do
    before { get :index }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template(:index) }
  end

  describe '#thank_you' do
    before { get :thank_you }

    it { expect(response).to have_http_status(:ok) }
    it { expect(response).to render_template(:thank_you) }
    it { expect(response).to render_template(layout: 'authentication') }
  end

  describe '#contact' do

    context 'without parameters' do
      it { expect { post :contact }.to raise_error(ActionController::ParameterMissing) }
    end

    context 'with correct parameters' do
      before { post :contact, contact: { name: 'xunda', email: 'xunda@email.com', subject: 'xunda subject' } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
      it { expect(flash[:error]).to be_nil }
    end

    context 'with one missing parameter' do
      before { post :contact, contact: { name: 'xunda', subject: 'xunda subject' } }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template(:index) }
      it { expect(flash[:error]).not_to be_nil }
    end

  end

end

require 'rails_helper'

describe RegistrationsController do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe 'GET new' do
    before { get :new }

    it { is_expected.to render_template(:new) }
    it { expect(assigns(:account_presenter)).to be_nil }
    it { expect(assigns(:user)).to be_instance_of(User) }
  end

  describe 'POST create' do

    context 'when valid input' do
      let(:attrs) { attributes_for(:user) }

      before { post :create, user: attrs }

      it { is_expected.to redirect_to thank_you_url }
      it { expect(flash[:notice]).to eq I18n.t('devise.registrations.signed_up_but_unconfirmed') }
    end

    context 'when invalid input' do
      let(:attrs) { attributes_for(:user) }

      before do
        attrs.delete(:birthday)
        post :create, user: attrs
      end

      it { is_expected.to render_template(:new) }
      it { expect(assigns(:user).errors.empty?).to be_falsey }
      it { expect(assigns(:account_presenter)).to be_nil }
    end

  end

  describe 'GET edit' do
    let!(:user) { create(:user) }
    login_user

    before do
      get :edit
    end

    it { expect(assigns(:account_presenter)).not_to be_nil }
  end

  describe 'PUT update' do
    let!(:account_atts) { { '0' => attributes_for(:account) } }
    let!(:user) { create(:user) }
    login_user

    context 'update with password' do
      context 'with valid attributes' do

        before do
          put :update, user: {
                                email: 'test2@test.com',
                                password: 'testtest',
                                password_confirmation: 'testtest',
                                current_password: user.password,
                                accounts_attributes: account_atts
                              }
        end

        it { is_expected.to redirect_to authenticated_root_url }
      end

      context 'with invalid attributes' do
        before do
          put :update, user: {
                                email: 'test2@test.com',
                                password: 'testtest',
                                password_confirmation: 'testtest',
                                current_password: ''
                              }
        end

        it { is_expected.to render_template :edit }
        it { expect(assigns(:user).errors).not_to be_empty }
        it { expect(assigns(:account_presenter)).not_to be_nil }
      end

    end

    context 'update without password' do

      before do
        put :update, user: {
                              email: user.email,
                              first_name: 'New Name',
                              current_password: '',
                              accounts_attributes: account_atts
                            }
      end

      it { is_expected.to redirect_to authenticated_root_url }
    end

    context 'update SelfEmployedAcccount' do
      let!(:account_atts) { { '0' => attributes_for(:account), '1' => attributes_for(:account_self_employed, hourly_rate: 50) } }

      before do
        put :update, user: {
                              email: user.email,
                              first_name: 'New Name',
                              current_password: '',
                              accounts_attributes: account_atts
                            }
      end

      it { is_expected.to redirect_to authenticated_root_url }
      it { expect(SelfEmployedAccount.first.hourly_rate).to eq 50 }
    end

  end

end

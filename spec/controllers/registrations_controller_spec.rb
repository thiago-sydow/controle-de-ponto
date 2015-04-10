require 'rails_helper'

describe RegistrationsController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET new" do
    before { get :new }

    it { is_expected.to render_template(:new) }
    it { expect(assigns(:user)).to be_instance_of(User) }
  end

  describe "POST create" do

    context 'when valid input' do
      let(:attrs) { attributes_for(:user) }

      before { post :create, user: attrs }

      it { is_expected.to redirect_to new_user_registration_url }
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
    end

  end

  describe "GET password" do
    context "with logged in user" do
      it "renders the :password view" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in regular
        get :password
        response.should render_template :password
      end

      it "assigns current_user to @user" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in regular
        get :password
        assigns(:user).should == regular
      end
    end
  end

  describe "PUT update" do
    before :each do
      @attrs = { name: regular.name, username: regular.username, email: regular.email, bio: regular.bio, website: regular.website, twitter: "test", current_password: "123qwe" }
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in regular
    end

    context "update with password" do
      context "with valid attributes" do
        it "redirects to root_url" do
          put :update, user: {email: "test2@test.com", current_password: "123qwe"}
          response.should redirect_to root_url
        end

        it "assigns current_user to @user" do
          put :update, user: {email: "test2@test.com", current_password: "123qwe"}
          assigns(:user).should == regular
        end
      end

      context "with invalid attributes" do
        it "renders edit template" do
          put :update, user: {email: "test2@test.com" , current_password: ""}
          response.should render_template :edit
        end

        it "assigns current_user to @user" do
          put :update, user: {email: "test2@test.com", current_password: ""}
          assigns(:user).should == regular
        end
      end
    end

    context "update without password" do
      it "redirects to root_url" do
        put :update, user: @attrs
        response.should redirect_to root_url
      end

      it "assigns current_user to @user" do
        put :update, user: @attrs
        assigns(:user).should == regular
      end
    end
  end

end

require 'rails_helper'

describe UserParams do

  context "for :sign_in" do
    let(:params) do
      ActionController::Parameters.new(user:
        {
          email:          'someone@me.com',
          password:       'password',
          remember_me:    true,
          to_be_filtered: 'meow'
        })
    end
    let(:expected_params) do
      {
        email:          'someone@me.com',
        password:       'password',
        remember_me:    true
      }
    end
    let(:sanitizer) do
      UserParams.new(User, :user, params)
    end

    subject { sanitizer.sanitize(:sign_in)                       }
    it      { should eq(expected_params.with_indifferent_access) }
  end

  context "for :sign_up" do
    let(:params) do
      ActionController::Parameters.new(user:
        {
          email: 'thiagovs05@gmail.com',
          password: 'password',
          password_confirmation: 'password',
          name: 'Thiago',
          birthday: Date.current,
          job: 'Ruby Developer',
          malicious_parameter: 'rawr'
        })
    end

    let(:expected_params) do
      {
        email: 'thiagovs05@gmail.com',
        password: 'password',
        password_confirmation: 'password',
        name: 'Thiago',
        birthday: Date.current,
        job: 'Ruby Developer'
      }
    end

    let(:sanitizer) do
      UserParams.new(User, :user, params)
    end

    subject { sanitizer.sanitize(:sign_up) }
    it      { expect(subject).to eq(expected_params.with_indifferent_access) }
  end
end

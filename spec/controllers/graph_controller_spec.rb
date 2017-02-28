require 'rails_helper'

RSpec.describe GraphController do
  USER_QUERY = <<-GRAPHQL
    query GetCurrentUser {
      currentUser {
        id, firstName
      }
    }
  GRAPHQL

  let(:user) { build_stubbed(:user, first_name: 'Anakin', id: 1) }

  before do
    allow(controller).to receive(:doorkeeper_token).and_return(double(acceptable?: true))
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #query' do
    describe 'when no query is provided' do
      before do
        post :query, params: {}
      end

      it 'returns a 400' do
        expect(response.status).to eq(400)
      end

      it 'returns a missing_graphql_query error kind' do
        expect(json['error']['kind']).to eq('missing_graphql_query')
      end
    end

    describe 'fetching the current user (currentUser)' do
      before do
        post :query, query: USER_QUERY
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'returns the expected payload' do
        expect(graph['currentUser']['id']).to eq(1)
        expect(graph['currentUser']['firstName']).to eq('Anakin')
      end
    end

    describe 'fetching variables' do
      let(:test_variables) { { 'testVariable' => { 'value1' => 'test' } } }

      describe 'when the informed parameter is a String' do
        it 'loads the variables to Graph Schema' do
          expect(Schema).to receive(:execute)
            .with(USER_QUERY, hash_including(variables: hash_including('testVariable'))).and_call_original

          post :query, query: USER_QUERY, variables: JSON.dump(test_variables)
        end
      end

      describe 'when the informed parameter is a JSON payload' do
        it 'loads the variables to Graph Schema' do
          expect(Schema).to receive(:execute)
            .with(USER_QUERY, hash_including(variables: hash_including('testVariable'))).and_call_original

          post :query, query: USER_QUERY, variables: test_variables
        end
      end
    end
  end

  describe 'GET #introspect' do
    before do
      post :introspect
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'returns the expected payload' do
      expect(graph['__schema']).to be_present
    end
  end
end

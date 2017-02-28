require 'rails_helper'

RSpec.describe Loaders::RecordLoader do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:loader) { described_class.for(User) }

    it 'loads the record for the given id' do
      returned = GraphQL::Batch.batch do
        loader.load(user.id)
      end

      expect(returned).to eq(user)
    end
  end
end

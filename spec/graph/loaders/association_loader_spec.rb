require 'rails_helper'

RSpec.describe Loaders::AssociationLoader do
  describe '#perform' do
    let!(:account) { create(:account) }
    let!(:days) { create_list(:day_record_sequence, 10, account: account) }

    context 'when the association exists' do
      let(:loader) { described_class.for(Account, :day_records, page: 1, page_size: 100) }

      it 'loads the record for the given id' do
        returned = GraphQL::Batch.batch do
          loader.load(account)
        end

        expect(returned.total_items_count).to eq(days.size)
        expect(returned.collection).to match_array(days)
      end
    end

    context 'when the association does not exist' do
      let(:loader) { described_class.for(Account, :xunda, page: 1, page_size: 100) }

      it 'raises and ArgumentError' do
        GraphQL::Batch.batch do
          expect { loader.load(account) }.to raise_error(ArgumentError, 'No association xunda on Account')
        end
      end
    end
  end
end

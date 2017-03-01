require 'rails_helper'

RSpec.describe ModelCollection do
  let(:paginated) { described_class.new(scope) }

  before(:all) do
    @account = create(:account)
    create_list(:day_record_sequence, 50, account: @account)
  end

  after(:all) do
    @account.destroy!
  end

  describe '#collection' do
    let(:scope) { DayRecord.where(account_id: @account.id).page(1) }

    it 'returns the association relation' do
      expect(paginated.collection).to eq(scope)
    end
  end

  describe '#has_next_page?' do
    context 'when the result is empty' do
      let(:scope) { DayRecord.none.page(1) }

      it { expect(paginated.has_next_page?).to be_falsey }
    end

    context 'when more pages are available' do
      let(:scope) { DayRecord.where(account_id: @account.id).page(1).per(25) }

      it { expect(paginated.has_next_page?).to be_truthy }
    end

    context 'when there is no more pages' do
      let(:scope) { DayRecord.where(account_id: @account.id).page(2).per(25) }

      it { expect(paginated.has_next_page?).to be_falsey }
    end

    context 'when the page informed is greater than total_pages' do
      let(:scope) { DayRecord.where(account_id: @account.id).page(10).per(25) }

      it { expect(paginated.has_next_page?).to be_falsey }
    end
  end

  describe 'total_pages' do
    let(:scope) { DayRecord.where(account_id: @account.id).page(1).per(25) }

    it { expect(paginated.total_pages).to eq(2) }
  end

  describe 'total_items_count' do
    let(:scope) { DayRecord.where(account_id: @account.id).page(1).per(25) }

    it { expect(paginated.total_items_count).to eq(50) }
  end
end

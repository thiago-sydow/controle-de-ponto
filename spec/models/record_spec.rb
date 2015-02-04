require 'rails_helper'

RSpec.describe Record, type: :model do

  let(:record_without_user) { build(:record, user: nil) }

  it { expect(create(:record)).to be_valid }
  it { expect(subject).to validate_presence_of :time }
  it { expect(subject).to belong_to :user }
  it { expect(record_without_user).not_to be_valid }

end

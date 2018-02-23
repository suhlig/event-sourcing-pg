# frozen_string_literal: true

require 'securerandom'

describe :UsersView do
  let(:uuid) { SecureRandom.uuid }

  before do
    Event.new(
      type: 'user_created',
      uuid: uuid,
      body: '{"name": "blah"}',
    ).save

    Event.new(
      type: 'user_updated',
      uuid: uuid,
      body: '{"name": "someone"}',
    ).save
  end

  it 'has no data' do
    users = Sequel::Model.db[:users_view].where(uuid: uuid)
    expect(users.count).to eq(0)
  end

  context 'it is refreshed' do
    before do
      Sequel::Model.db.refresh_view(:users_view)
    end

    it 'has the latest user data' do
      users = Sequel::Model.db[:users_view].where(uuid: uuid)
      expect(users.count).to eq(1)
      expect(users.first[:name]).to eq('someone')
    end
  end
end

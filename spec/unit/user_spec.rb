# frozen_string_literal: true
require 'securerandom'

describe :User do
  context 'an insert event occurred' do
    let(:uuid) { SecureRandom.uuid }

    before do
      Sequel::Model.db[:events].insert(
        type: 'user_create',
        uuid: uuid,
        body: '{"name": "blah"}',
      )
    end

    it 'has a new user' do
      user = Sequel::Model.db[:users].where(uuid: uuid)
      expect(user.first[:name]).to eq('blah')
    end

    context 'an update event occurred' do
      before do
        Sequel::Model.db[:events].insert(
          type: 'user_update',
          uuid: uuid,
          body: '{"name": "fasel"}',
        )
      end

      it 'has updated attributes' do
        user = Sequel::Model.db[:users].where(uuid: uuid)
        expect(user.first[:name]).to eq('fasel')
      end

      context 'the materialized view is up to date' do
        before do
          Sequel::Model.db[:events].insert(
            type: 'user_update',
            uuid: uuid,
            body: '{"name": "someone"}',
          )
        end

        before do
          Sequel::Model.db.refresh_view(:users_view)
        end

        it 'has the latest user data' do
          user = Sequel::Model.db[:users].where(uuid: uuid)
          expect(user.first[:name]).to eq('someone')
        end
      end
    end
  end
end

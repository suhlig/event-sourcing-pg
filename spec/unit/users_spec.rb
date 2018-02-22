# frozen_string_literal: true

describe :users do
  context 'an insert event occurred' do
    before(:all) do
      Sequel::Model.db[:events].insert(
        type: 'user_create',
        uuid: '11111111-1111-1111-1111-111111111111',
        body: '{"name": "blah"}',
      )
    end

    it 'has a new user' do
      expect(Sequel::Model.db[:users].count).to eq(1)
      expect(Sequel::Model.db[:users].first[:name]).to eq('blah')
    end

    context 'an update event occurred' do
      before(:all) do
        Sequel::Model.db[:events].insert(
          type: 'user_update',
          uuid: '11111111-1111-1111-1111-111111111111',
          body: '{"name": "fasel"}',
        )
      end

      it 'has updated attributes' do
        expect(Sequel::Model.db[:users].count).to eq(1)
        expect(Sequel::Model.db[:users].first[:name]).to eq('fasel')
      end

      context 'the materialized view is up to date' do
        before(:all) do
          Sequel::Model.db[:events].insert(
            type: 'user_update',
            uuid: '11111111-1111-1111-1111-111111111111',
            body: '{"name": "someone"}',
          )
        end

        before do
          Sequel::Model.db.refresh_view(:users_view)
        end

        it 'has the latest user data' do
          expect(Sequel::Model.db[:users_view].count).to eq(1)
          expect(Sequel::Model.db[:users].first[:name]).to eq('someone')
        end
      end
    end
  end
end

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

    context 'an update event occurred, too' do
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
    end
  end
end

# frozen_string_literal: true

require 'securerandom'

describe User do
  context 'a user_created event occurred' do
    let(:uuid) { SecureRandom.uuid }

    before do
      Event.new(
        type: 'user_created',
        uuid: uuid,
        body: '{"name": "blah"}',
      ).save
    end

    it 'has a new user' do
      user = User.where(uuid: uuid).first
      expect(user.name).to eq('blah')
    end

    context 'a user_updated event occurred' do
      before do
        Event.new(
          type: 'user_updated',
          uuid: uuid,
          body: '{"name": "fasel"}',
        ).save
      end

      it 'has updated attributes' do
        user = User.where(uuid: uuid).first
        expect(user.name).to eq('fasel')
      end
    end
  end
end

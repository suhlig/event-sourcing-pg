Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      UUID :uuid, null: false
      String :name
      DateTime :inserted_at, null: false, default: Sequel.function('now')
      DateTime :updated_at, null: false, default: Sequel.function('now')
      index %i[uuid], type: :btree
    end
  end
end

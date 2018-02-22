Sequel.migration do
  change do
    create_table(:events) do
      primary_key :id
      UUID :uuid, null: false
      String :type
      Jsonb :body, null: false
      DateTime :inserted_at, null: false, default: Sequel.function('statement_timestamp')
    end
  end
end

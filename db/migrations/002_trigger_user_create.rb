Sequel.migration do
  up do
    run File.read("#{__dir__}/create-user-triggers.sql")
  end

  down do
    run File.read("#{__dir__}/drop-user-triggers.sql")
  end
end

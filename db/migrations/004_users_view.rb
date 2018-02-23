Sequel.migration do
  up do
    run File.read("#{__dir__}/create-users-view.sql")
  end

  down do
    run File.read("#{__dir__}/drop-users-view.sql")
  end
end

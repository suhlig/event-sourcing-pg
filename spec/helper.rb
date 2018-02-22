# frozen_string_literal: true

require 'sequel'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # config.disable_monkey_patching!
  config.warnings = false

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = 'spec/failure-state'

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.before(:suite) do
    Sequel::Model.db = Sequel.connect(ENV.fetch('DB'))
    Sequel.extension :migration
    Sequel::Migrator.run(Sequel::Model.db, 'db/migrations')

    %i[events users].each do |table|
      Sequel::Model.db[table].truncate
    end
  end

  config.after(:suite) do
    Sequel::Model.db.disconnect
  end
end

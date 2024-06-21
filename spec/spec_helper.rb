require "bundler/inline"

gemfile do
  source 'https://rubygems.org'
  gem "rspec", require: true
end

RSpec.configure do |c|
  # Enable flags like --only-failures and --next-failure
  c.example_status_persistence_file_path = ".rspec_status"

  c.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end
end

# frozen_string_literal: true

require 'dotenv/load'
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
require 'bundler/setup'
Bundler.require(:default, :development)
require 'soapy_cake'
require 'webmock/rspec'

Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

Time.zone = 'Europe/Berlin'

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.expect_with :rspec do |c|
    # Disable the `should` syntax
    c.syntax = :expect
  end

  # Setting this config option `false` removes rspec-core's monkey patching of the
  # top level methods like `describe`, `shared_examples_for` and `shared_context`
  # on `main` and `Module`. The methods are always available through the `RSpec`
  # module like `RSpec.describe` regardless of this setting.
  # For backwards compatibility this defaults to `true`.
  #
  # https://relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/global-namespace-dsl
  config.expose_dsl_globally = false
end

ENV['CAKE_API_KEY'] = 'cake-api-key' if ENV['CAKE_API_KEY'].blank?
ENV['CAKE_DOMAIN'] = 'cake-partner-domain.com' if ENV['CAKE_DOMAIN'].blank?
ENV['CAKE_TIME_ZONE'] = 'Europe/Berlin' if ENV['CAKE_TIME_ZONE'].blank?
ENV['CAKE_WRITE_ENABLED'] = 'yes' if ENV['CAKE_WRITE_ENABLED'].blank?

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.filter_sensitive_data('cake-api-key') { ENV['CAKE_API_KEY'] }
  c.filter_sensitive_data('cake-partner-domain.com') { ENV['CAKE_DOMAIN'] }
  c.default_cassette_options = { match_requests_on: %i[method uri body] }

  # allow codeclimate-test-reporter to phone home
  c.ignore_hosts 'codeclimate.com'
end

require 'spork'
require 'factory_girl'

Spork.prefork do
  require 'rspec'
  require 'simplecov'
  require 'awesome_print'

  SimpleCov.start

  RSpec.configure do |config|
    ENV['POMODORI_ENV'] = 'test'

    config.mock_with :rspec do |config|
      config.syntax = [:expect, :should]
    end

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.run_all_when_everything_filtered = true
    config.filter_run_including :focus => true

    config.include FactoryGirl::Syntax::Methods

    FactoryGirl.find_definitions

    ## TODO: Put the set-up block here for configs. Alternately, I require
    ## files for the spec files themselves. Might be an interesting bit of
    ## inception, that.

    ## Other strategy: Rescue the exception, run setup?

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = 'random'

  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload

  # Require Ruby files under the lib directory
  RSpec.configure do |config|
    base_dir = File.expand_path("../../", __FILE__)
    Dir["#{base_dir}/lib/**/*.rb"].each {|f| require f}
  end
end

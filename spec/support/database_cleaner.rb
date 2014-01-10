# From: http://devblog.avdi.org/2012/08/31/configuring-database_cleaner-with-rails-rspec-capybara-and-selenium/

require 'sequel'

RSpec.configure do |config|
  db_path = "sqlite://#{ENV["HOME"]}/.pomodori/pomodori_test.sqlite3"
  DB      = Sequel.connect(db_path)

  config.before(:suite) do
    DB[:notifications].truncate
    DB[:events].truncate
  end

  config.after(:each) do
    DB[:notifications].truncate
    DB[:events].truncate
  end
end

# actions: start, halfway, close, complete, cancel

require 'pp'

module Pomodori
  database  = Pomodori::Database.new
  DB        = database.connect
  CONFIG    = database.config

  class Notification < Sequel::Model
    attr_accessor :config
  end
end

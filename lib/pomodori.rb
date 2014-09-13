require_relative "pomodori/configuration"
require_relative "pomodori/database"
require_relative "pomodori/setup"
require_relative "pomodori/event"
require_relative "pomodori/pomodoro"
require_relative "pomodori/pausa"
require_relative "pomodori/lunga_pausa"
require_relative "pomodori/notification"
require_relative "pomodori/notifier"
require_relative "pomodori/notifier/error"
require_relative "pomodori/notifier/osx" ## FIXME: Only on Mac OS X
require_relative "pomodori/notifier/stdout"
require_relative "string_underscore"

# Everything is a level down.
module Pomodori
  CONFIGURATION = Pomodori::Configuration.new
  database      = Pomodori::Database.new( { configuration: CONFIGURATION } )
  DB            = database.connect
end

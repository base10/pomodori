require_relative "pomodori/configure"
require_relative "pomodori/database"
require_relative "pomodori/setup"
require_relative "pomodori/event"
require_relative "pomodori/pomodoro"
require_relative "pomodori/pausa"
require_relative "pomodori/lunga_pausa"

module Pomodori
end

class String
  # Pulled from http://stackoverflow.com/questions/1509915/converting-camel-case-to-underscore-case-in-ruby
  # 
  # ruby mutation methods have the expectation to return self if a mutation 
  # occurred, nil otherwise. (see http://www.ruby-doc.org/core-1.9.3/String.html#method-i-gsub-21)
  def to_underscore!
    gsub!(/(.)([A-Z])/,'\1_\2') && downcase!
  end

  def to_underscore
    dup.tap { |s| s.to_underscore! }
  end
end

require 'factory_girl'

FactoryGirl.define do
  factory :pomodoro, class: 'Pomodori::Pomodoro' do
    summary       'Starting Project Lorum Ipsum'
    duration      '25'

    created_at    '2013-06-05T22:07:18-04:00'
    started_at    '2013-06-05T22:07:19-04:00'
    completed_at  '2013-06-05T22:32:19-04:00'
  end

  factory :break, class: 'Pomodori::Break' do
    summary       'Break time!'
    duration      '5'
  
    created_at    '2013-06-05T22:32:20-04:00'
    started_at    '2013-06-05T22:32:20-04:00'
    completed_at  '2013-06-05T22:37:20-04:00'
  end

  factory :long_break, class: 'Pomodori::LongBreak' do
    summary       'Take a walk!'
    duration      '15'

    created_at    '2013-06-06T18:59:27-04:00'  
    started_at    '2013-06-06T19:06:13-04:00'
    completed_at  '2013-06-06T19:21:13-04:00'
  end
end

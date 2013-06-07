require 'factory_girl'

FactoryGirl.define do
  factory :pomodoro do
    summary       'Starting Project Lorum Ipsum'
    duration      '25'
    kind          'pomodoro'
  
    started_at    '2013-06-05T22:07:19-04:00'
    completed_at  '2013-06-05T22:32:19-04:00'
  end

  factory :break do
    summary       'Break time!'
    duration      '5'
    kind          'break'
  
    started_at    '2013-06-05T22:32:20-04:00'
    completed_at  '2013-06-05T22:37:20-04:00'
  end

  factory :long_break do
    summary       'Take a walk!'
    duration      '15'
    kind          'long_break'
  
    started_at    '2013-06-06T19:06:13-04:00'
    completed_at  '2013-06-06T19:21:13-04:00'
  end
end

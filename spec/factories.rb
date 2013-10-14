require 'factory_girl'

FactoryGirl.define do
  factory :pomodoro, class: 'Pomodori::Pomodoro' do
    created_at    '2013-06-05T22:07:18-04:00'
    started_at    '2013-06-05T22:07:19-04:00'
    completed_at  '2013-06-05T22:32:19-04:00'
  end

  factory :pausa, class: 'Pomodori::Pausa' do
    created_at    '2013-06-05T22:32:20-04:00'
    started_at    '2013-06-05T22:32:20-04:00'
    completed_at  '2013-06-05T22:37:20-04:00'
  end

  factory :lunga_pausa, class: 'Pomodori::LungaPausa' do
    created_at    '2013-06-06T18:59:27-04:00'
    started_at    '2013-06-06T19:06:13-04:00'
    completed_at  '2013-06-06T19:21:13-04:00'
  end

  factory :note_start, class: 'Pomodori::Notification' do
    action        'start'
    deliver_at    '2013-06-05T22:32:20-04:00'
  end
end

require "spec_helper"
require "stringio"

describe "Pomodori::Notification" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    test_config = <<-EOF
---
version: 1
database:
  production: pomodori_production.sqlite3
  test: pomodori_test.sqlite3
  development: pomodori_development.sqlite3
pomodoro:
  summary: Working on Lorum Ipsum
  duration: 25
  count_to_long_break: 4
pausa:
  summary: Taking a short break
  duration: 5
lunga_pausa:
  summary: Taking a long break
  duration: 15
notifier: stdout
EOF

    #File.any_instance.stub(:read).with.and_return(test_config)

    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    Pomodori::Pomodoro.any_instance.stub(:id).and_return( 23 )
    Pomodori::Pomodoro.any_instance.stub(:pk).and_return( 23 )

    @setup.run
    @database = Pomodori::Database.new
    @database.connect

    @config = @database.config
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  describe "saving" do
    it "saves a valid object" do
      notification = FactoryGirl.build(:note_start)

      expect(notification.valid?).to be_true
      expect { notification.save }.not_to raise_error
    end

    it "expects an action" do
      notification = FactoryGirl.build(:note_start, action: '')
      expect(notification.valid?).to be_false
    end

    it "expects a deliver_at" do
      notification = FactoryGirl.build(:note_start, deliver_at: nil)
      expect(notification.valid?).to be_false
    end

    it "expects an event" do
      notification = FactoryGirl.build(:note_start, event: nil)
      expect(notification.valid?).to be_false
    end
  end

  describe "fulfillment" do
    let ( :notification ) { FactoryGirl.build(:note_start) }
    let ( :output )       { double('output').as_null_object }

    it "has a strategy" do
      #expect( notification.notifier_strategy ).to eq('Pomodori::Notifier::Stdout')
      expect( notification.notifier_strategy ).to eq('Pomodori::Notifier::Osx')
    end

    it "presents a notification" do
      notification.stub(:notifier_strategy).and_return('Pomodori::Notifier::Stdout')

      notification.output = output
      notification.deliver

      expect(output).to include(notification.title)
      expect(output).to include(notification.message)
    end

    it "updates completed_at" do
      notification.stub(:notifier_strategy).and_return('Pomodori::Notifier::Stdout')

      notification.output = output
      notification.deliver

      expect(notification.completed_at).not_to be(nil)
    end
  end

  # This is prior to subclassing and using a Factory
  describe "message and title for the notification mechanism" do
    let ( :notification ) { FactoryGirl.build(:note_start) }
    let ( :event )        { FactoryGirl.build(:pomodoro) }

    it "returns a title based on the event" do
      expect(notification.title).to include(event.kind)
      expect(notification.title).to include(notification.action)
    end

    it "it returns a message based on the event" do
      expect(notification.message).to include(event.kind)
    end
  end
end
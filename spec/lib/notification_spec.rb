require "spec_helper"

describe "Pomodori::Notification" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    Pomodori::Pomodoro.any_instance.stub(:id).and_return( 23 )
    Pomodori::Pomodoro.any_instance.stub(:pk).and_return( 23 )

    @setup.run
    @database = Pomodori::Database.new
    @database.connect
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

    it "has a strategy" do
      pending
    end

    it "presents a notification" do
      pending
      #expect(notification.deliver).
    end

    it "updates completed_at" do
      pending
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

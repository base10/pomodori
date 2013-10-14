require "spec_helper"

describe "Pomodori::Notification" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    @setup = Pomodori::Setup.new
    allow(@setup).to receive(:default_config_path).and_return( test_config_path )

    Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

    Pomodori::Pomodoro.any_instance.stub(:id).and_return( 23 )

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
end

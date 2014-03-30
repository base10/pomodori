#-*- mode: ruby; x-counterpart: ../../lib/pomodori/pomodoro.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require "spec_helper"
require "pp"

describe "Pomodori::Pomodoro" do
  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  # TODO: Convert to 'let' blocks
  before(:each) do
    Pomodori::Configuration.any_instance.stub(:default_config_path).and_return( test_config_path )
    Pomodori::Notification.any_instance.stub(:process)

    @setup          = Pomodori::Setup.new
    @configuration  = @setup.configuration
    @setup.run

    @database = Pomodori::Database.new( { configuration: @configuration } )
    @database.connect

    Pomodori::Pomodoro.send(:public, *Pomodori::Pomodoro.protected_instance_methods)
  end

  after(:each) do
    FileUtils.rm_rf test_config_path
  end

  # TODO: Once the Pomodoro tests are written, abstract them to a shared
  # example group
  describe "saving" do
    it "saves a valid object" do
      pomodoro = build(:pomodoro)

      expect(pomodoro.valid?).to be_true
      expect { pomodoro.save }.to_not raise_error
    end

    # Initial creation needs summary, duration, kind, state, created_at
    it "expects a summary" do
      pomodoro = build(:pomodoro, summary: '')
      expect(pomodoro.valid?).to be_false

      pomodoro = build(:pomodoro, summary: nil)
      expect(pomodoro.valid?).to be_false
    end

    it "expects a duration" do
      pomodoro = build(:pomodoro, duration: '')
      expect(pomodoro.valid?).to be_false
    end

    it "expects a kind" do
      pomodoro = build(:pomodoro)
      pomodoro.stub(:kind).and_return(nil)

      expect(pomodoro.valid?).to be_false
    end

    it "expects a state" do
      pomodoro = build(:pomodoro, state: '')
      expect(pomodoro.valid?).to be_false

      pomodoro = build(:pomodoro, state: nil)
      expect(pomodoro.valid?).to be_false
    end

    it "fills in a creation date and time" do
      pomodoro = build(:pomodoro,
                                  created_at:   nil,
                                  started_at:   nil,
                                  completed_at: nil
                                )

      expect(pomodoro.valid?).to be_true
      expect(pomodoro.created_at.nil?).to be_false
    end
  end

  describe "initialization" do
    let(:pomodoro) { build(:pomodoro,
                                      created_at:   nil,
                                      started_at:   nil,
                                      completed_at: nil
                                )
                    }

    it "sets a kind" do
      expect(Pomodori::Pomodoro.determine_kind).to eq('pomodoro')
      expect(pomodoro.kind).to eq('pomodoro')
    end

    it "sets a state" do
      expect(pomodoro.state).not_to be_nil
      expect(pomodoro.state).to eq('ready')
    end

    describe "duration" do
      it "sets a default duration from config" do
        expect(pomodoro.duration).not_to be_nil
        expect(pomodoro.duration).to eq(25)
      end

      # TODO: CLI provided duration
    end

    describe "summary" do
      it "sets a default summary from config" do
        expect(pomodoro.summary).not_to be_nil
        expect(pomodoro.summary).to include("Working on")
      end

      # TODO: CLI provided summary
    end
  end

  describe "starting a pomodoro" do
    let(:pomodoro) { build(:pomodoro,
                                      created_at:   nil,
                                      started_at:   nil,
                                      completed_at: nil
                                )
                    }

    it "changes state to 'in_progress'" do
      expect(pomodoro.state).to eq("ready")
      pomodoro.start
      expect(pomodoro.state).to eq("in_progress")
    end

    it "saves state to the database" do
      pomodoro.start

      db_pomodoro = Pomodori::Pomodoro.find(id: pomodoro.id)

      expect(db_pomodoro.state).to eq('in_progress')
      expect(db_pomodoro.object_id).not_to eq(pomodoro.object_id)
    end

    it "sets started_at" do
      pomodoro.start
      expect(pomodoro.started_at).not_to be_nil
    end

    it "cannot be completed" do
      expect(pomodoro.transition.trigger?(:complete) ).to eq(false)
    end

    it "can be cancelled" do
      expect(pomodoro.transition.trigger?(:cancel) ).to eq(true)
    end

    it "builds state_notifications" do
      pomodoro.state_notifications.should_receive(:push).at_least(4).times
      pomodoro.start
    end

    # Solving based on http://stackoverflow.com/questions/9800992/how-to-say-any-instance-should-receive-any-number-of-times-in-rspec/9998793#9998793
    it "processes state_notifications" do
      count = 0
      Pomodori::Notification.any_instance.stub(:process) { |arg| count += 1 }
      pomodoro.start
      expect(count).to be >= 1
    end

    it "clears state_notifications" do
      pomodoro.start
      expect( pomodoro.state_notifications.size ).to eq 0
    end
  end

  describe "completing a pomodoro" do
    let(:pomodoro) { build(:pomodoro,
                                      started_at:   nil,
                                      completed_at: nil
                                )
                    }

    before(:each) do
      pomodoro.start
    end

    it "changes state to 'completed'" do
      expect(pomodoro.state).to eq("in_progress")
      pomodoro.complete
      expect(pomodoro.state).to eq("completed")
    end

    it "saves state to the database" do
      pomodoro.complete

      db_pomodoro = Pomodori::Pomodoro.find(id: pomodoro.id)

      expect(db_pomodoro.state).to eq('completed')
      expect(db_pomodoro.object_id).not_to eq(pomodoro.object_id)
    end

    it "sets completed_at" do
      pomodoro.complete
      expect(pomodoro.completed_at).not_to be_nil
    end

    it "cannot be cancelled after completion" do
      pomodoro.complete
      expect(pomodoro.transition.trigger?(:cancel) ).to eq(false)
    end

    it "cannot be started" do
      pomodoro.complete
      expect(pomodoro.transition.trigger?(:start) ).to eq(false)
    end
  end

  describe "cancelling a pomodoro" do
    let(:pomodoro) { build(:pomodoro) }

    before(:each) do
      pomodoro.start
    end

    it "changes state to 'cancelled'" do
      expect(pomodoro.state).to eq("in_progress")
      pomodoro.cancel
      expect(pomodoro.state).to eq("cancelled")
    end

    it "saves state to the database" do
      pomodoro.cancel

      db_pomodoro = Pomodori::Pomodoro.find(id: pomodoro.id)

      expect(db_pomodoro.state).to eq('cancelled')
      expect(db_pomodoro.object_id).not_to eq(pomodoro.object_id)
    end

    it "sets completed_at" do
      pomodoro.cancel
      expect(pomodoro.cancelled_at).not_to be_nil
    end

    it "cannot be started" do #expect exception here
      pomodoro.complete
      expect(pomodoro.transition.trigger?(:start) ).to eq(false)
    end

    it "cannot be completed" do #expect exception here (may need to add db cleaner)
      pomodoro.complete
      expect(pomodoro.transition.trigger?(:complete) ).to eq(false)
    end
  end

  describe "implements notification population methods" do
    let(:pomodoro) { build(:pomodoro) }

    ['start', 'cancel', 'save'].each do |action|
      method_name = "add_#{action}_notifications"

      it "\##{method_name}" do
        expect( pomodoro.respond_to?( method_name.to_sym ) ).to eq(true)
      end
    end
  end

  describe "pomodori completed today" do
    before(:each) do
      pomodori = Array.new
      3.times { pomodori.push build(:pomodoro) }

      pomodori.each do |pomodoro|
        pomodoro.start
        pomodoro.complete
      end
    end

    it "#done_today gets a list" do
      expect(Pomodori::Pomodoro.done_today.size).to eq(3)
    end
  end

  # TODO: Testing of business logic/workflow
  # TODO: Test for failure without a config
end

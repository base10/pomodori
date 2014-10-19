#-*- mode: ruby; x-counterpart: ../../../lib/pomodori/service/pomodoro_add.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require "spec_helper"

describe "Pomodori::Service::PomodoroAdd" do
  let ( :duration ) { 35 }
  let ( :summary )  { 'This is a summary' }
  let ( :arguments ) do
    {
      'duration'  => duration,
      'summary'   => summary
    }
  end

  subject { Pomodori::Service::PomodoroAdd.new( arguments ) }

  before(:each) do
    pomodoro = instance_spy( Pomodori::Pomodoro )
    allow( Pomodori::Pomodoro ).to receive( :new ).and_return( pomodoro )
  end

  describe "instantiation" do
    it "can accept a populated hash" do
      expect { Pomodori::Pomodoro.new( arguments ) }.not_to raise_error
      subject
    end

    it "can accept an empty hash" do
      expect { Pomodori::Pomodoro.new( {} ) }.not_to raise_error
      subject
    end

    it "can have no arguments" do
      expect { Pomodori::Pomodoro.new }.not_to raise_error
      subject
    end

    it "provides a length for duration" do
      arguments['length'] = arguments['duration']
      expect( Pomodori::Pomodoro ).to receive( :new ).with( arguments )
      subject
    end
  end

  describe "saving" do
    it "calls save on the instantiated Pomdori" do
      expect( subject.pomodori ).to receive( :save )
      subject.run
    end
  end
end

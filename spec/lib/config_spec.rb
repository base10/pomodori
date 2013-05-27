require "spec_helper"
require "fileutils"

describe Pomodori::Config do
  it "is setup correctly" do
    expect { 1 }.to be_true
  end
  
  it "raises an error without a config file" do
    expect { Pomodori::Config.new }. to raise_error(Errno::ENOENT)
  end
end

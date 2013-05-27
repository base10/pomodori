require "spec_helper"
require "fileutils"

describe Pomodori::Config do
  it "raises an error without a config file" do
    expect { Pomodori::Config.new }.to raise_error(Errno::ENOENT)
  end

  it "raises an error with an invalid YAML file" do
    File.stub(:exists?).and_return(true)
    File.stub(:read).and_return("- foo\rfoo -\r - bar")

    expect { Pomodori::Config.new() }.to raise_error(SyntaxError)
  end
end

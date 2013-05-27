require "spec_helper"

describe Pomodori::Config do
  it "raises an error without a config file" do
    expect { Pomodori::Config.new }.to raise_error(Errno::ENOENT)
  end

  it "raises an error with an invalid YAML file" do
    File.stub(:exists?).and_return(true)
    File.stub(:read).and_return("- foo\rfoo -\r - bar")

    expect { Pomodori::Config.new }.to raise_error(SyntaxError)
  end

  it "sets the config accessor" do
    File.stub(:exists?).and_return(true)
    File.stub(:read).and_return("---\nfoo: bar\nbippy: baz")
    
    config_obj = Pomodori::Config.new
    
    expect( config_obj.config ).to_not    be(nil)
    expect( config_obj.config.class ).to  be(Hash)
    expect( config_obj.config['foo'] ).to eq('bar')
  end
end

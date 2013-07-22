require "spec_helper"

module Pomodori
  class Example  
    include Pomodori::Configure
  end
end

describe Pomodori::Example do

  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  before(:each) do
    Pomodori::Example.any_instance.stub(:default_config_path).and_return( test_config_path )
  end

  after(:each) do
    ENV['POMODORI_ENV'] = "test"
  end

  describe "config" do 
    it "has a baseline config if no config file is available" do
      expect { @example = Pomodori::Example.new }.to_not raise_error
      expect(@example.config).to have_key('database')
    end

    it "raises an error with an invalid YAML file" do
      File.stub(:exists?).and_return(true)
      File.stub(:read).and_return("- foo\rfoo -\r - bar")

      expect { Pomodori::Example.new }.to raise_error(SyntaxError)
    end

    it "sets the config accessor" do
      File.stub(:exists?).and_return(true)
      File.stub(:read).and_return("---\nfoo: bar\nbippy: baz")
    
      config_obj = Pomodori::Example.new
    
      expect( config_obj.config ).to_not    be(nil)
      expect( config_obj.config.class ).to  be(Hash)
      expect( config_obj.config['foo'] ).to eq('bar')
    end
  end

  describe 'environments' do
    describe "known or default" do
      let ( :environment )  { 'test' }

      before(:each) do
        ENV['POMODORI_ENV'] = environment
      
        @config = Pomodori::Example.new
      end

      describe "test" do
        let ( :environment ) { 'test' }

        it "supports test environment" do
          expect( @config.environment ).to eq('test')
        end
      end
    
      describe "development" do
        let ( :environment ) { 'development' }
    
        it "supports development environment" do
          expect( @config.environment ).to eq('development')
        end    
      end

      describe "production" do
        let ( :environment ) { 'production' }

        it "supports production environment" do
          expect( @config.environment ).to eq('production')
        end
      end

      describe "nil (default)" do
        let ( :environment ) { nil }
    
        it "sets a default environment" do
          expect( @config.environment ).to eq('production')
        end
      end
    end

    describe "bad environment raises Exception" do
      it "sets a default environment" do
        ENV['POMODORI_ENV'] = "OHAI"

        expect { Pomodori::Example.new }.to raise_error
      end
    end
  end
end

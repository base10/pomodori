#-*- mode: ruby; x-counterpart: ../../lib/pomodori/configuration.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-
require "spec_helper"

describe Pomodori::Configuration do

  let ( :test_config_path ) { File.expand_path( "../../dotpomodori", __FILE__ ) }

  subject { Pomodori::Configuration.new }

  before(:each) do
    Pomodori::Configuration.any_instance.stub(:default_config_path).and_return( test_config_path )
  end

  after(:each) do
    ENV['POMODORI_ENV'] = "test"
  end

  describe "config" do
    # FIXME: This test needs to be rewritten
    it "has a baseline config if no config file is available" do
      expect { subject }.to_not raise_error
      expect(subject.config).to have_key('database')
    end

    it "raises an error with an invalid YAML file" do
      File.stub(:exists?).and_return(true)
      File.stub(:read).and_return("- foo\rfoo -\r - bar")

      expect { subject }.to raise_error(Psych::SyntaxError)
    end

    it "sets the config accessor" do
      File.stub(:exists?).and_return(true)
      File.stub(:read).and_return("---\nfoo: bar\nbippy: baz")

      expect( subject.config ).to_not    be(nil)
      expect( subject.config.class ).to  be(Hash)
      expect( subject.config['foo'] ).to eq('bar')
    end
  end

  # FIXME: I think a lot of this could get
  describe 'environments' do
    describe "known or default" do
      let ( :environment )  { 'test' }

      before(:each) do
        ENV['POMODORI_ENV'] = environment
      end

      describe "test" do
        let ( :environment ) { 'test' }

        it "supports test environment" do
          expect( subject.environment ).to eq('test')
        end
      end

      describe "development" do
        let ( :environment ) { 'development' }

        it "supports development environment" do
          expect( subject.environment ).to eq('development')
        end
      end

      describe "production" do
        let ( :environment ) { 'production' }

        it "supports production environment" do
          expect( subject.environment ).to eq('production')
        end
      end

      describe "nil (default)" do
        let ( :environment ) { nil }

        it "sets a default environment" do
          expect( subject.environment ).to eq('production')
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

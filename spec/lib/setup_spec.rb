#-*- mode: ruby; x-counterpart: ../../lib/pomodori/setup.rb; tab-width: 2; indent-tabs-mode: nil; x-auto-expand-tabs: true;-*-

require_relative "../spec_helper"
require 'fileutils'

describe Pomodori::Setup do
  let ( :test_config_path )     { File.expand_path( "../../dotpomodori", __FILE__ ) }

  subject { Pomodori::Setup.new }

  before(:each) do
    Pomodori::Configuration.any_instance.stub(:default_config_path).and_return( test_config_path )
  end

  after(:each) do
    FileUtils.rm_rf test_config_path

    ENV['POMODORI_ENV'] = 'test'
  end

  describe "data directory setup" do
    it "creates the .pomodori folder if it doesn't exist" do
      expect { subject.ensure_config_path_exists }.to_not raise_error
      expect( File.directory?( subject.configuration.default_config_path ) ).to be true
    end
  end

  describe "config file handling" do
    before(:each) do
      subject.ensure_config_path_exists
    end

    context "write config file" do
      it "creates the config file if it doesn't exist" do
        expect { subject.ensure_config_file_exists }.to_not raise_error
        expect( File.exists?( subject.configuration.default_config_file ) ).to be(true)
      end
    end

    context "don't overwrite existing config" do
      before (:each) do
        subject.ensure_config_file_exists
      end

      it "respects an existing config file" do
        expect(FileUtils).to receive(:cp).with(subject.initial_config_file).exactly(0).times
        subject.ensure_config_file_exists
      end
    end
  end

  describe "database" do
    env_list = ['production', 'development', 'test']

    def setup_by_env(env)
      ENV['POMODORI_ENV'] = env

      setup = Pomodori::Setup.new

      setup.ensure_config_path_exists
      setup.ensure_config_file_exists

      setup
    end

    def test_path(setup_obj)
      env = setup_obj.configuration.environment
      setup_obj.configuration.default_config_path + "/" + setup_obj.configuration.config['database'][env]
    end

    env_list.each do |kenv|
      before(:each) do
        Pomodori::Database.any_instance.stub(:default_config_path).and_return( test_config_path )

        setup_by_env(kenv)
      end

      describe "new database for #{kenv}" do
        it "sets the correct database path by environment" do
          subject      = setup_by_env(kenv)
          @test_path  = test_path(subject)

          expect( subject.database.database_file ).to eq(@test_path)
          expect( subject.database.database_file ).to match(/#{kenv}/)
        end

        it "creates a new database if one doesn't exist" do
          expect { subject.ensure_database_exists }.to_not raise_error
          expect( File.exists?( test_path(subject) ) ).to eq(true)
        end

        it "creates the database structure for #{kenv}" do
          expect { subject.setup_database_schema }.to_not raise_error
          # TODO: Add a test to validate that schema migrations have run
        end
      end
    end
  end
end

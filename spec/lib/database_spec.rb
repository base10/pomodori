require "spec_helper"

describe Pomodori::Database do
  describe "config" do
    before(:each) do
      Pomodori::Database.any_instance.stub(:default_config_file).and_return( File.expand_path("../../config/pomodori_test.yml", __FILE__ ))
    end

    it "has a config" do
      db_obj = Pomodori::Database.new

      expect(db_obj.config).to_not be(nil)
    end
  end
end

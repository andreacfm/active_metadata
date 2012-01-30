require "spec_helper"

describe "active_metadata.yml" do

  context "given the active_metadata.yml parsed" do

    before do
      @envs = ['test','development']
      @config = YAML.load(File.read("config/active_metadata.yml"))
    end

    it "should have a streamables config" do
      test_envs{|env| @config[env]['streamables'].should_not be_nil}
    end


  end

  def test_envs &block
    @envs.each do |env|
      yield env
    end
  end

end
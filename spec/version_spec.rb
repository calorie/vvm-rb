require 'spec_helper'

describe 'Version' do
  before :all do
    @version = Version.new
    @version.dot_dir = @vvm_tmp
  end

  describe 'list' do
    it 'echo available vim versions' do
      expect(@version.list).to match(/start\n(v7-.+\n)+tip$/)
    end
  end

  describe 'versions' do
    it 'echo installed vim versions' do
      expect(@version.versions).to eq("v7-3-969\nv7-4")
    end
  end
end

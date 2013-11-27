require 'spec_helper'

describe 'Version' do
  describe 'list' do
    it 'echo available vim versions' do
      expect(Version.list.join("\n")).to match(/start\n(v7-.+\n)+tip$/)
    end
  end

  describe 'versions' do
    it 'echo installed vim versions' do
      expect(Version.versions.join("\n")).to eq("v7-4-083\nv7-4-103")
    end
  end
end

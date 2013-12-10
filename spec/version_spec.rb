require 'spec_helper'
require 'fileutils'

describe 'Version' do
  describe 'list' do
    context 'vimorg dirctory exists' do
      it 'echo available vim versions' do
        expect(Version.list.join("\n")).to match(/start\n(v7-.+\n)+tip$/)
      end
    end
    context 'vimorg dirctory is not found' do
      before do
        FileUtils.rm_rf(get_vimorg_dir)
      end
      it 'echo nothing' do
        expect(Version.list).to eq []
      end
    end
  end

  describe 'versions' do
    context 'vims dirctory exists' do
      it 'echo installed vim versions' do
        expect(Version.versions.join("\n")).to eq("v7-4-083\nv7-4-103")
      end
    end
    context 'vims dirctory is not found' do
      before do
        FileUtils.rm_rf(get_vims_dir)
      end
      it 'echo nothing' do
        expect(Version.versions).to eq []
      end
    end
  end
end

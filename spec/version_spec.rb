require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe 'Version' do
  describe 'list' do
    it 'echo available vim versions' do
      expect(Version.list.join("\n")).to match(/start\n(v7-.+\n)+tip$/)
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
        @tmp_vvmroot = ENV['VVMROOT']
        @tmp2 = Dir.mktmpdir
        ENV['VVMROOT'] = @tmp2
      end

      after do
        ENV['VVMROOT'] = @tmp_vvmroot
        FileUtils.rm_rf(@tmp2)
      end

      it 'echo nothing' do
        expect(Version.versions).to eq []
      end
    end
  end

  describe 'latest' do
    it 'return latest vim version' do
      expect(Version.latest).to match(/^v7-.+$/)
    end
  end

  describe 'convert' do
    it 'version to tag' do
      expect(Version.convert('7.4.112')).to eq 'v7-4-112'
    end
  end

  describe 'format' do

    context 'tag' do
      it 'return formated vim version' do
        expect(Version.format('v7-4-112')).to eq 'v7-4-112'
      end
    end

    context 'dicimal version' do
      it 'return formated vim version' do
        expect(Version.format('7.4.112')).to eq 'v7-4-112'
      end
    end

    context 'latest' do
      it 'return latest vim version' do
        expect(Version.format('latest')).to match(/^v7-.+$/)
      end
    end
  end
end

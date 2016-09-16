require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe 'Version' do
  describe 'list' do
    it 'vimorg_dir not found' do
      allow(File).to receive(:exist?).and_return(false)
      expect(proc { Vvm::Version.list }).to raise_error
    end

    it 'echo available vim versions' do
      expect(Vvm::Version.list.join("\n")).to match(/\A(v\d\..+\n)+tip\z/)
    end
  end

  describe 'versions' do
    context 'vims dirctory exists' do
      it 'echo installed vim versions' do
        expect(Vvm::Version.versions.join("\n")).to eq "#{VERSION1}\n#{VERSION2}"
      end
    end
    context 'vims dirctory is not found' do
      before do
        @tmp_vvmroot   = ENV['VVMROOT']
        @tmp2          = Dir.mktmpdir
        ENV['VVMROOT'] = @tmp2
      end

      after do
        ENV['VVMROOT'] = @tmp_vvmroot
        FileUtils.rm_rf(@tmp2)
      end

      it 'echo nothing' do
        expect(Vvm::Version.versions).to eq []
      end
    end
  end

  describe 'latest' do
    it 'return latest vim version' do
      expect(Vvm::Version.latest).to match(/\Av\d\..+\z/)
    end
  end

  describe 'current' do
    context 'current version is system' do
      before { Vvm::Switcher.new('system').use }
      it 'return current vim version' do
        expect(Vvm::Version.current).to eq 'system'
      end
    end

    context 'current version is not system' do
      before { Vvm::Switcher.new(VERSION1).use }
      it 'return current vim version' do
        expect(Vvm::Version.current).to eq VERSION1
      end
    end
  end

  describe 'convert' do
    it 'version to tag' do
      expect(Vvm::Version.convert('7.4.112')).to eq 'v7.4.112'
    end
  end

  describe 'format' do
    context 'tag' do
      it 'return formated vim version' do
        expect(Vvm::Version.format('v7.4.112')).to eq 'v7.4.112'
      end
    end

    context 'dicimal version' do
      it 'return formated vim version' do
        expect(Vvm::Version.format('7.4a.001')).to eq 'v7.4a.001'
      end
    end

    context 'latest' do
      it 'return latest vim version' do
        expect(Vvm::Version.format('latest')).to match(/\Av\d\..+\z/)
      end
    end
  end
end

require 'spec_helper'

describe 'Validator' do
  include Vvm::Validator

  NEW_VERSION = 'v7-4-050'

  describe 'has_hg?' do
    context 'hg is installed' do
      before { allow(Kernel).to receive(:find_executable).and_return(true) }

      it 'success to run the method' do
        expect(has_hg?).to be_truthy
      end
    end

    context 'hg is not installed' do
      before { allow(Kernel).to receive(:find_executable).and_return(false) }

      it 'cannot run the method' do
        expect(proc { has_hg? }).to raise_error
      end
    end
  end

  describe 'version?' do
    before(:all) { $* << %w(vvm-rb install) }

    context 'available tag' do
      before { $*[2] = NEW_VERSION }

      it 'success to run the method' do
        expect(version?).to be_truthy
      end
    end

    context 'latest' do
      before { $*[2] = 'latest' }

      it 'success to run the method' do
        expect(version?).to be_truthy
      end
    end

    context 'tag is not available' do
      before { $*[2] = '--use' }

      it 'cannot run the method' do
        expect(proc { version? }).to raise_error
      end
    end
  end

  describe 'new_version?' do
    context 'new version' do
      it 'success to run the method' do
        expect(new_version?(NEW_VERSION)).to be_truthy
      end
    end

    context 'version is installed' do
      it 'cannot run the method' do
        expect(proc { new_version?(VERSION1) }).to raise_error
      end
    end
  end

  describe 'has_version?' do
    context 'version is installed' do
      it 'success to run the method' do
        expect(has_version?(VERSION1)).to be_truthy
      end
    end

    context 'version is not installed' do
      it 'cannot run the method' do
        expect(proc { has_version?(NEW_VERSION) }).to raise_error
      end
    end
  end
end

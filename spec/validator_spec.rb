require 'spec_helper'

describe 'Validator' do
  include Vvm::Validator

  NEW_VERSION = 'v7-4-050'

  describe 'validate_before_invoke' do
    before do
      allow(Vvm::Validator).to receive(:new_version?).and_return(true)
      allow(Vvm::Validator).to receive(:installed_version?).and_return(true)
      allow(Vvm::Validator).to receive(:version?).and_return(true)
      allow(Vvm::Validator).to receive(:hg?).and_return(true)
    end

    context 'install' do
      it 'new_version?' do
        expect(Vvm::Validator).to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end

      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end
    end

    context 'reinstall' do
      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('reinstall')
      end
    end

    context 'rebuild' do
      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end

      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end
    end

    context 'use' do
      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end

      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end
    end

    context 'list' do
      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('list')
      end
    end

    context 'uninstall' do
      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('uninstall')
      end

      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('uninstall')
      end
    end
  end

  describe 'hg?' do
    context 'hg is installed' do
      before { allow(Vvm::Validator).to receive(:find_executable).and_return(true) }

      it 'success to run the method' do
        expect(Vvm::Validator.hg?).to be_truthy
      end
    end

    context 'hg is not installed' do
      before { allow(Vvm::Validator).to receive(:find_executable).and_return(false) }

      it 'cannot run the method' do
        expect(proc { Vvm::Validator.hg? }).to raise_error
      end
    end
  end

  describe 'version?' do
    before(:all) { $* << %w(vvm install) }

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

  describe 'installed_version?' do
    context 'version is installed' do
      it 'success to run the method' do
        expect(installed_version?(VERSION1)).to be_truthy
      end
    end

    context 'version is not installed' do
      it 'cannot run the method' do
        expect(proc { installed_version?(NEW_VERSION) }).to raise_error
      end
    end
  end
end

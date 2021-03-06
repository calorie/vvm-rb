require 'spec_helper'

describe 'Validator' do
  include Vvm::Validator

  NEW_VERSION = 'v7.4.050'.freeze

  describe 'validate_before_invoke' do
    before do
      allow(Vvm::Validator).to receive(:new_version?).and_return(true)
      allow(Vvm::Validator).to receive(:installed_version?).and_return(true)
      allow(Vvm::Validator).to receive(:version?).and_return(true)
      allow(Vvm::Validator).to receive(:hg?).and_return(true)
    end

    context 'install' do
      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end

      it 'new_version?' do
        expect(Vvm::Validator).to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).not_to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('install')
      end
    end

    context 'reinstall' do
      it 'version?' do
        expect(Vvm::Validator).not_to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('reinstall')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('reinstall')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('reinstall')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('reinstall')
      end
    end

    context 'rebuild' do
      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('rebuild')
      end
    end

    context 'use' do
      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end

      it 'hg?' do
        expect(Vvm::Validator).not_to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('use')
      end
    end

    context 'list' do
      it 'version?' do
        expect(Vvm::Validator).not_to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('list')
      end

      it 'hg?' do
        expect(Vvm::Validator).to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('list')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('list')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).not_to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('list')
      end
    end

    context 'versions' do
      it 'version?' do
        expect(Vvm::Validator).not_to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('versions')
      end

      it 'hg?' do
        expect(Vvm::Validator).not_to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('versions')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('versions')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).not_to receive(:installed_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('versions')
      end
    end

    context 'uninstall' do
      it 'version?' do
        expect(Vvm::Validator).to receive(:version?).with(no_args)
        Vvm::Validator.validate_before_invoke('uninstall')
      end

      it 'hg?' do
        expect(Vvm::Validator).not_to receive(:hg?).with(no_args)
        Vvm::Validator.validate_before_invoke('uninstall')
      end

      it 'new_version?' do
        expect(Vvm::Validator).not_to receive(:new_version?).with(no_args)
        Vvm::Validator.validate_before_invoke('uninstall')
      end

      it 'installed_version?' do
        expect(Vvm::Validator).to receive(:installed_version?).with(no_args)
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
        expect(proc { Vvm::Validator.hg? }).to raise_error SystemExit
      end
    end
  end

  describe 'version?' do
    before(:all) { $* << %w[vvm install] }

    context 'available tag' do
      before(:all) { $*[2] = NEW_VERSION }

      it 'success to run the method' do
        expect(version?).to be_truthy
      end
    end

    context 'latest' do
      before(:all) { $*[2] = 'latest' }

      it 'success to run the method' do
        expect(version?).to be_truthy
      end
    end

    context 'tag is not available' do
      before(:all) { $*[2] = '--use' }

      it 'cannot run the method' do
        expect(proc { version? }).to raise_error SystemExit
      end
    end
  end

  describe 'new_version?' do
    before do
      allow(Vvm::Installer).to receive(:pull).and_return(true)
    end

    context 'with arg' do
      context 'new version' do
        it 'success to run the method' do
          expect(new_version?(NEW_VERSION)).to be_truthy
        end
      end

      context 'version is installed' do
        it 'cannot run the method' do
          expect(proc { new_version?(VERSION1) }).to raise_error SystemExit
        end
      end
    end

    context 'without arg' do
      before(:all) { $* << %w[vvm install] }

      context 'new version' do
        before(:all) { $*[2] = NEW_VERSION }

        it 'success to run the method' do
          expect(new_version?).to be_truthy
        end
      end

      context 'version is installed' do
        before(:all) { $*[2] = VERSION1 }

        it 'cannot run the method' do
          expect(proc { new_version? }).to raise_error SystemExit
        end
      end
    end
  end

  describe 'installed_version?' do
    context 'with arg' do
      context 'version is installed' do
        it 'success to run the method' do
          expect(installed_version?(VERSION1)).to be_truthy
        end
      end

      context 'version is not installed' do
        it 'cannot run the method' do
          expect(proc { installed_version?(NEW_VERSION) }).to raise_error SystemExit
        end
      end
    end

    context 'without arg' do
      before(:all) { $* << %w[vvm install] }

      context 'version is installed' do
        before(:all) { $*[2] = VERSION1 }

        it 'success to run the method' do
          expect(installed_version?).to be_truthy
        end
      end

      context 'version is not installed' do
        before(:all) { $*[2] = NEW_VERSION }

        it 'cannot run the method' do
          expect(proc { installed_version? }).to raise_error SystemExit
        end
      end
    end
  end
end

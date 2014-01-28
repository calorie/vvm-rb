require 'spec_helper'
include VvmRb::Base

describe 'Validator' do
  NEW_VERSION = 'v7-4-050'

  describe 'check_hg' do
    def dummy_method ; end
    before_method(:dummy_method) { check_hg }

    context 'hg is installed' do
      before { Kernel.stub(:system).and_return(true) }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'hg is not installed' do
      before { Kernel.stub(:system).and_return(false) }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'check_tag' do
    def dummy_method ; end
    before_method(:dummy_method) { check_tag }

    before(:all) { $* << %w(vvm-rb install) }

    context 'available tag' do
      before { $*[2] = NEW_VERSION }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'latest' do
      before { $*[2] = 'latest' }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'tag is not available' do
      before { $*[2] = '--use' }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'new_version?' do
    def dummy_method ; end

    context 'new version' do
      before_method(:dummy_method) { new_version?(NEW_VERSION) }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'version is installed' do
      before_method(:dummy_method) { new_version?(VERSION1) }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'version_exist?' do
    def dummy_method ; end

    context 'version is installed' do
      before_method(:dummy_method) { version_exist?(VERSION1) }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'version is not installed' do
      before_method(:dummy_method) { version_exist?(NEW_VERSION) }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end
end

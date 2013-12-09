require 'spec_helper'
include VvmRb::Base

describe 'Validator' do

  describe 'check_hg' do
    def dummy_method ; end
    before_method(:dummy_method) { check_hg }

    context 'hg is installed' do
      before do
        Kernel.stub(:system).and_return(true)
      end

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'hg is not installed' do
      before do
        Kernel.stub(:system).and_return(false)
      end

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'check_tag' do
    def dummy_method ; end
    before_method(:dummy_method) { check_tag }

    before :all do
      $* << ['vvm-rb', 'install']
    end

    context 'available tag' do
      before do
        $*[2] = 'v7-4-050'
      end

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'latest' do
      before do
        $*[2] = 'latest'
      end

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'tag is not available' do
      before do
        $*[2] = '--use'
      end

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'new_version?' do
    def dummy_method ; end

    context 'new version' do
      before_method(:dummy_method) { new_version?('v7-4-050') }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'version is installed' do
      before_method(:dummy_method) { new_version?('v7-4-103') }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end

  describe 'version_exist?' do
    def dummy_method ; end

    context 'version is installed' do
      before_method(:dummy_method) { version_exist?('v7-4-103') }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'version is not installed' do
      before_method(:dummy_method) { version_exist?('v7-4-050') }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end
end

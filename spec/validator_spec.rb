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

    context 'available tag' do
      before { $*[1] = 'v7-4-050' }

      it 'success to run the method' do
        expect(dummy_method).to be_nil
      end
    end

    context 'hg is not installed' do
      before { $*[1] = '--enable-rubyinterp' }

      it 'cannot run the method' do
        expect(proc { dummy_method }).to raise_error
      end
    end
  end
end

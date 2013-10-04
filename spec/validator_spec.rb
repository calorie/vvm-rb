require 'spec_helper'
include Validator

describe 'Validator' do
  def dummy_method ; end
  before_method(:dummy_method) { validations }

  describe 'check_hg' do
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
end

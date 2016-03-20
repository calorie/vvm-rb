require 'spec_helper'

describe 'Switcher' do
  describe 'use' do
    context 'system vim' do
      before :all do
        Vvm::Switcher.new('system').use
      end

      it 'delete current' do
        expect(File.exist?(current_dir)).not_to be_truthy
      end
    end

    context 'different version' do
      before :all do
        version = VERSION1
        Vvm::Switcher.new(version).use
        @vims_dir = vims_dir(version)
        @current  = current_dir
      end

      it 'exist current' do
        expect(File.exist?(@current)).to be_truthy
      end

      it 'switch current' do
        expect(File.readlink(@current)).to eq @vims_dir
      end
    end

    context 'unknown version' do
      before :all do
        @switcher = Vvm::Switcher.new('v7.5')
      end

      it 'raise error' do
        expect(proc { @switcher.use }).to raise_error
      end
    end
  end
end

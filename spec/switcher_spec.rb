require 'spec_helper'

describe 'Switcher' do
  describe 'use' do
    context 'system vim' do
      before :all do
        switcher = Switcher.new('system')
        switcher.dot_dir = @vvm_tmp
        switcher.use
      end

      it 'delete current' do
        expect(File.exists?(get_current_dir)).not_to be_true
      end
    end

    context 'different version' do
      before :all do
        version = 'v7-4'
        switcher = Switcher.new(version)
        switcher.dot_dir = @vvm_tmp
        switcher.use
        @vims_dir = get_vims_dir(version)
        @current  = get_current_dir
      end

      it 'exist current' do
        expect(File.exists?(@current)).to be_true
      end

      it 'switch current' do
        expect(File.readlink(@current)).to eq(@vims_dir)
      end
    end

    context 'unknown version' do
      before :all do
        @switcher = Switcher.new('v7-5')
        @switcher.dot_dir = @vvm_tmp
      end

      it 'raise error' do
        expect(proc { @switcher.use }).to raise_error
      end
    end
  end
end

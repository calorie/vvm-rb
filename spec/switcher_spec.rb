require 'spec_helper'

describe 'Switcher' do
  describe 'use' do
    context 'system vim' do
      before :all do
        switcher = Switcher.new('system')
        switcher.use
      end

      it 'delete current' do
        expect(Dir.exists?("#{VIMS_DIR}/current")).not_to be_true
      end
    end

    context 'different version' do
      before :all do
        switcher = Switcher.new('v7-4')
        switcher.use
        @vims_dir = "#{VIMS_DIR}/v7-4"
        @current  = "#{VIMS_DIR}/current"
      end

      it 'exist current' do
        expect(Dir.exists?(@current)).to be_true
      end

      it 'switch current' do
        expect(File.readlink(@current)).to eq(@vims_dir)
      end
    end

    context 'unknown version' do
      before :all do
        @switcher = Switcher.new('v7-5')
      end

      it 'raise error' do
        expect(proc { @switcher.use }).to raise_error
      end
    end
  end
end

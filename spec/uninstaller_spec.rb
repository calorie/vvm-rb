require 'spec_helper'

describe 'Uninstaller' do
  describe 'uninstall' do
    context 'vim version is currently used' do
      before :all do
        version = 'v7-4'
        Switcher.new(version).use
        @uninstaller = Uninstaller.new(version)
      end

      it 'raise error' do
        expect(proc { @uninstaller.uninstall }).to raise_error
      end
    end

    context 'can uninstall version' do
      before :all do
        @version = 'v7-3-969'
        Uninstaller.new(@version).uninstall
      end

      it 'delete src dir' do
        expect(File.exists?(get_src_dir(@version))).not_to be_true
      end

      it 'delete vims dir' do
        expect(File.exists?(get_vims_dir(@version))).not_to be_true
      end
    end
  end
end

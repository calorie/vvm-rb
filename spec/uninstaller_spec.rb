require 'spec_helper'

describe 'Uninstaller' do
  describe 'uninstall' do
    context 'vim version is currently used' do
      before :all do
        version = VERSION1
        Switcher.new(version).use
        @uninstaller = Uninstaller.new(version)
      end

      after :all do
        Switcher.new('system').use
      end

      it 'raise error' do
        expect(proc { @uninstaller.uninstall }).to raise_error
      end
    end

    context 'can uninstall version' do
      before :all do
        @version = VERSION1
        Uninstaller.new(@version).uninstall
      end

      it 'delete src dir' do
        expect(File.exist?(get_src_dir(@version))).not_to be_true
      end

      it 'delete vims dir' do
        expect(File.exist?(get_vims_dir(@version))).not_to be_true
      end
    end
  end
end

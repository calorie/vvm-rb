require 'spec_helper'

describe 'Uninstaller' do
  describe 'uninstall' do
    context 'vim version is currently used' do
      before :all do
        Cli.start('use v7-4'.split)
        @uninstaller = Uninstaller.new('v7-4')
      end

      it 'raise error' do
        expect(proc { @uninstaller.uninstall }).to raise_error
      end
    end

    context 'can uninstall version' do
      before :all do
        @version = 'v7-3-969'
        @uninstaller = Uninstaller.new(@version)
        @uninstaller.uninstall
      end

      it 'delete src dir' do
        expect(Dir.exists?("#{SRC_DIR}/#{@version}")).not_to be_true
      end

      it 'delete vims dir' do
        expect(Dir.exists?("#{VIMS_DIR}/#{@version}")).not_to be_true
      end
    end
  end
end

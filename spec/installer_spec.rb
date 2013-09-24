require 'fileutils'
require 'spec_helper'

describe 'Installer' do
  describe 'install' do
    before :all do
      Cli.start('uninstall v7-3-969'.split)
      Cli.start('uninstall v7-4'.split)
      FileUtils.rm_rf(REPOS_DIR)
      FileUtils.rm_rf(ETC_DIR)
      @version = 'v7-4'
      @installer = Installer.new(@version, [])
    end

    context 'fetch' do
      before :all do
        @installer.fetch
      end

      it 'exists vimorg dir' do
        expect(Dir.exists?("#{REPOS_DIR}/vimorg")).to be_true
      end
    end

    context 'checkout' do
      before :all do
        @installer.checkout
      end

      it 'exists src dir' do
        expect(Dir.exists?("#{SRC_DIR}/#{@version}")).to be_true
      end
    end

    context 'configure & make_install' do
      before :all do
        @installer.configure
        @installer.make_install
      end

      it 'exists vims dir' do
        expect(Dir.exists?("#{VIMS_DIR}/#{@version}")).to be_true
      end
    end

    context 'cp_etc' do
      before :all do
        @installer.cp_etc
      end

      it 'exists etc dir' do
        expect(Dir.exists?(ETC_DIR)).to be_true
      end

      it 'exists login file' do
        expect(File.exists?("#{ETC_DIR}/login")).to be_true
      end
    end
  end
end

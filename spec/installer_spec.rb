require 'spec_helper'

describe 'Installer' do
  describe 'install' do
    before :all do
      FileUtils.rm_rf(get_src_dir)
      FileUtils.rm_rf(get_vims_dir)
      FileUtils.rm_rf(get_repos_dir)
      FileUtils.rm_rf(get_etc_dir)
      ENV['VVMOPT'] = '--enable-rubyinterp'
      @version = 'v7-4-103'
      @installer = Installer.new(@version)
    end

    context 'fetch' do
      before :all do
        Installer.fetch
      end

      it 'exists vimorg dir' do
        expect(File.exists?(get_vimorg_dir)).to be_true
      end
    end

    context 'pull' do
      before :all do
        Installer.pull
      end

      it 'exists vimorg dir' do
        expect($?.success?).to be_true
      end
    end

    context 'checkout' do
      before :all do
        @installer.checkout
      end

      it 'exists src dir' do
        expect(File.exists?(get_src_dir(@version))).to be_true
      end
    end

    context 'configure & make_install' do
      before :all do
        @installer.configure
        @installer.make_install
      end

      it 'exists vims dir' do
        expect(File.exists?(get_vims_dir(@version))).to be_true
      end
    end

    context 'cp_etc' do
      before :all do
        Installer.cp_etc
      end

      it 'exists etc dir' do
        expect(File.exists?(get_etc_dir)).to be_true
      end

      it 'exists login file' do
        expect(File.exists?(get_login_file)).to be_true
      end
    end

    context 'vvmopt' do
      let(:vim) { "#{get_vims_dir(@version)}/bin/vim" }

      it 'enable rubyinterp' do
        expect(`#{vim} --version |grep ruby`).to match(/\+ruby/)
      end
    end
  end

  describe 'rebuild' do
    before :all do
      @version = 'v7-4-103'
      @installer = Installer.new(@version)
    end

    context 'make_clean' do
      before :all do
        @installer.make_clean
      end

      it 'not exists objects dir' do
        expect(Dir["#{get_src_dir(@version)}/src/objects/*"].empty?).to be_true
      end
    end
  end
end

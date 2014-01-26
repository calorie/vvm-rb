require 'spec_helper'

describe 'Installer' do
  describe 'install' do
    before :all do
      FileUtils.rm_rf(get_src_dir)
      FileUtils.rm_rf(get_vims_dir)
      FileUtils.rm_rf(get_repos_dir)
      FileUtils.rm_rf(get_etc_dir)
      ENV['VVMOPT'] = '--enable-rubyinterp'
      @version      = 'v7-4-103'
      @installer    = Installer.new(@version, [], true)
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
      context 'login file not exist' do
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
      context 'login file exists and it is not latest' do
        before :all do
          FileUtils.stub(:compare_file).and_return(false)
        end

        it 'exists login file' do
          path = File.join(File.dirname(__FILE__), '..', 'etc', 'login')
          login = File.expand_path(path)
          expect(FileUtils).to receive(:cp).with(login, get_etc_dir)
          Installer.cp_etc
        end
      end
    end

    context 'vvmopt' do
      let(:vim) { File.join(get_vims_dir(@version), 'bin', 'vim') }

      it 'enable rubyinterp' do
        expect(`#{vim} --version |grep ruby`).to match(/\+ruby/)
      end
    end
  end

  describe 'rebuild' do
    before :all do
      @version   = 'v7-4-103'
      @installer = Installer.new(@version, [], true)
    end

    context 'make_clean' do
      before :all do
        @installer.make_clean
      end

      it 'not exists objects dir' do
        path = File.join(get_src_dir(@version), 'src', 'objects', '*')
        expect(Dir[path].empty?).to be_true
      end
    end
  end
end

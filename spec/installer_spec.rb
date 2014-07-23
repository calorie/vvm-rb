require 'spec_helper'

describe 'Installer', disable_cache: true do
  before :all do
    ENV['VVMOPT'] = '--enable-rubyinterp'
    @version      = VERSION1
    @installer    = Installer.new(@version, [], true)
  end

  let(:version_src_dir) { get_src_dir(@version) }
  let(:version_vims_dir) { get_vims_dir(@version) }
  let(:vim) { File.join(version_vims_dir, 'bin', 'vim') }

  describe 'install' do
    context 'fetch', clean: true do
      before(:all) { Installer.fetch }

      it 'exists vimorg dir' do
        expect(File.exist?(get_vimorg_dir)).to be_truthy
      end

      it 'success to clone' do
        expect($?.success?).to be_truthy
      end

      it 'exists configure file' do
        expect(File.exist?(File.join(get_vimorg_dir, 'configure'))).to be_truthy
      end
    end

    context 'pull', clean: true, vimorg: true do
      before :all do
        Dir.chdir(get_vimorg_dir) { system('hg rollback') }
        Installer.pull
      end

      it 'success to pull' do
        expect($?.success?).to be_truthy
      end

      it 'vim is uptodate' do
        Dir.chdir(get_vimorg_dir) do
          expect(`export LANG=en_US.UTF-8;hg pull`).to match(/no changes found/)
        end
      end
    end

    context 'checkout', clean: true, vimorg: true do
      before :all do
        @installer.checkout
      end

      it 'exists src dir' do
        expect(File.exist?(version_src_dir)).to be_truthy
      end

      it 'exists configure file' do
        configure = File.join(version_src_dir, 'configure')
        expect(File.exist?(configure)).to be_truthy
      end
    end

    context 'configure & make_install', clean: true, vimorg: true, src: true do
      before :all do
        @installer.configure
        @installer.make_install
      end

      it 'exists vims dir' do
        expect(File.exist?(version_vims_dir)).to be_truthy
      end

      it 'can execute vim' do
        expect(system("#{vim} --version > /dev/null 2>&1")).to be_truthy
      end

      it 'enable rubyinterp' do
        expect(`#{vim} --version |grep ruby`).to match(/\+ruby/)
      end
    end

    context 'cp_etc', clean: true do
      context 'login file not exist' do
        before(:all) { Installer.cp_etc }

        it 'exists etc dir' do
          expect(File.exist?(get_etc_dir)).to be_truthy
        end

        it 'exists login file' do
          expect(File.exist?(get_login_file)).to be_truthy
        end
      end

      context 'login file exists and it is not latest' do
        before do
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
  end

  describe 'rebuild' do
    context 'make_clean', clean: true, src: true do
      before :all do
        @installer.make_clean
      end

      it 'not exists objects dir' do
        path = File.join(version_src_dir, 'src', 'objects', '*')
        expect(Dir[path].empty?).to be_truthy
      end
    end
  end
end

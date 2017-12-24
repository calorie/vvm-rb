require 'spec_helper'
require 'mkmf'

describe 'Installer', disable_cache: true do
  before :all do
    ruby_path     = ENV['RBENV_ROOT'] ? find_executable('ruby') : '/usr/bin/ruby'
    ENV['VVMOPT'] = "--enable-rubyinterp=dynamic --with-ruby-command=#{ruby_path}"
    @version      = VERSION1
    @installer    = Vvm::Installer.new(@version, [], true)
  end

  let(:version_src_dir) { src_dir(@version) }
  let(:version_vims_dir) { vims_dir(@version) }
  let(:vim) { File.join(version_vims_dir, 'bin', 'vim') }

  describe 'install' do
    context 'fetch', clean: true do
      before(:all) { Vvm::Installer.fetch }

      it 'exists vimorg dir' do
        expect(File.exist?(vimorg_dir)).to be_truthy
      end

      it 'success to clone' do
        expect($?.success?).to be_truthy
      end

      it 'exists configure file' do
        expect(File.exist?(File.join(vimorg_dir, 'configure'))).to be_truthy
      end
    end

    context 'pull', clean: true, vimorg: true do
      before :all do
        Dir.chdir(vimorg_dir) { system('hg rollback') }
      end

      it 'vimorg_dir not found' do
        allow(File).to receive(:exist?).with(vimorg_dir).and_return(false)
        allow(Vvm::Installer).to receive(:fetch).and_return(true)
        expect(Vvm::Installer).to receive(:fetch)
        Vvm::Installer.pull
      end

      it 'success to pull' do
        expect($?.success?).to be_truthy
      end

      it 'vim is uptodate' do
        Dir.chdir(vimorg_dir) do
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
        before(:all) { Vvm::Installer.cp_etc }

        it 'exists etc dir' do
          expect(File.exist?(etc_dir)).to be_truthy
        end

        it 'exists login file' do
          expect(File.exist?(login_file)).to be_truthy
        end
      end

      context 'login file exists and it is not latest' do
        before do
          allow(FileUtils).to receive(:compare_file).and_return(false)
        end

        it 'exists login file' do
          path = File.join(File.dirname(__FILE__), '..', 'etc', 'login')
          login = File.expand_path(path)
          expect(FileUtils).to receive(:cp).with(login, etc_dir)
          Vvm::Installer.cp_etc
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

  describe 'message' do
    before { system('') }

    it 'command failed' do
      allow($?).to receive(:success?).and_return(false)
      expect { @installer.message }.to_not output(/success/).to_stdout
    end

    it 'silent' do
      allow($?).to receive(:success?).and_return(true)
      expect { @installer.message }.to_not output(/success/).to_stdout
    end

    it 'success' do
      allow($?).to receive(:success?).and_return(true)
      installer = Vvm::Installer.new(@version, [])
      expect { installer.message }.to output(/success/).to_stdout
    end
  end
end

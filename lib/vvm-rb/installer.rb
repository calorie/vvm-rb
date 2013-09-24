require 'fileutils'

class Installer
  include Validator

  def initialize(version, conf = nil)
    @version = version
    @conf    = conf
  end

  def install
    fetch
    checkout
    configure
    make_install
    cp_etc

    print "\e[32m"
    puts <<-EOS

Vim is successfully installed.  For daily use,
please add the following line into your ~/.bash_login etc:

test -f ~/.vvm-rb/etc/login && source ~/.vvm-rb/etc/login

    EOS
    print "\e[0m"
  end

  def rebuild
    make_clean
    configure
    make_install

    print "\e[32m"
    puts <<-EOS

Vim is successfully rebuilded.
    EOS
    print "\e[0m"
  end

  def fetch
    FileUtils.mkdir_p(REPOS_DIR)
    repos_dir = get_repos_dir
    unless Dir.exists?(repos_dir)
      system("hg clone #{VIM_URI} #{repos_dir}")
    end
    Dir.chdir(repos_dir) { system('hg pull') }
  end

  def checkout
    FileUtils.mkdir_p(SRC_DIR)
    repos_dir = get_repos_dir
    src_dir = get_src_dir(@version)
    unless Dir.exists?(src_dir)
      system("cd #{repos_dir} && hg archive -t tar -r #{@version} -p #{@version} - | (cd #{SRC_DIR} && tar xf -)")
    end
  end

  def configure
    vims_dir = get_vims_dir(@version)
    src_dir = get_src_dir(@version)
    default = "--prefix=#{vims_dir}"
    Dir.chdir src_dir do
      system("./configure #{default} #{@conf.join(' ')}")
    end
  end

  def make_clean
    src_dir = get_src_dir(@version)
    Dir.chdir src_dir do
      system('make clean')
    end
  end

  def make_install
    src_dir = get_src_dir(@version)
    Dir.chdir src_dir do
      system('make all install')
    end
  end

  def cp_etc
    unless File.exists?(get_login_file)
      FileUtils.mkdir_p(ETC_DIR)

      login = File.expand_path(File.dirname(__FILE__) + '/../../etc/login')
      FileUtils.cp(login, ETC_DIR)
    end
  end

  before(:fetch, :checkout) { validations }

  private

  def get_repos_dir
    return "#{REPOS_DIR}/vimorg"
  end

  def get_src_dir(version)
    return "#{SRC_DIR}/#{version}"
  end

  def get_vims_dir(version)
    return "#{VIMS_DIR}/#{version}"
  end

  def get_login_file
    return "#{ETC_DIR}/login"
  end
end

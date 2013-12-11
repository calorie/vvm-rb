require 'fileutils'

class Installer
  def initialize(version, conf)
    vvmopt = ENV['VVMOPT']
    @version = version
    @conf = conf.flatten.empty? && vvmopt ? vvmopt.split(' ') : conf
  end

  def self.fetch
    FileUtils.mkdir_p(get_repos_dir)
    repos_dir = get_vimorg_dir
    system("hg clone #{VIM_URI} #{repos_dir}") unless File.exists?(repos_dir)
  end

  def self.pull
    Dir.chdir(get_vimorg_dir) { system('hg pull') }
  end

  def checkout
    src_dir = get_src_dir
    FileUtils.mkdir_p(src_dir)
    unless File.exists?(get_src_dir(@version))
      archive = "hg archive -t tar -r #{@version} -p #{@version} -"
      expand = "(cd #{src_dir} && tar xf -)"
      Dir.chdir get_vimorg_dir do
        system("#{archive} | #{expand}")
      end
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

  def self.cp_etc
    unless File.exists?(get_login_file)
      etc_dir = get_etc_dir
      FileUtils.mkdir_p(etc_dir)
      login = File.expand_path(File.dirname(__FILE__) + '/../../etc/login')
      FileUtils.cp(login, etc_dir)
    end
  end
end

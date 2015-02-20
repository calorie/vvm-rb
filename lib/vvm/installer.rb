require 'fileutils'

module Vvm
  class Installer
    def initialize(version, conf, silent = false)
      vvmopt   = ENV['VVMOPT']
      @silent  = silent ? '> /dev/null 2>&1' : ''
      @version = version
      @conf    = conf.flatten.empty? && vvmopt ? vvmopt.split(' ') : conf
    end

    def self.fetch
      FileUtils.mkdir_p(get_repos_dir)
      repos_dir = get_vimorg_dir
      system("hg -q clone #{VIM_URI} #{repos_dir}") unless File.exist?(repos_dir)
    end

    def self.pull
      Dir.chdir(get_vimorg_dir) { system('hg -q pull') }
    end

    def checkout
      src_dir = get_src_dir
      FileUtils.mkdir_p(src_dir)
      return if File.exist?(get_src_dir(@version))
      archive = "hg archive -t tar -r #{@version} -p #{@version} -"
      expand  = "(cd #{src_dir} && tar xf -)"
      Dir.chdir get_vimorg_dir do
        system("#{archive} | #{expand} #{@silent}")
      end
    end

    def configure
      vims_dir = get_vims_dir(@version)
      src_dir  = get_src_dir(@version)
      default  = "--prefix=#{vims_dir}"
      Dir.chdir src_dir do
        system("./configure #{default} #{@conf.join(' ')} #{@silent}")
      end
    end

    def make_clean
      src_dir = get_src_dir(@version)
      Dir.chdir src_dir do
        system("make clean #{@silent}")
      end
    end

    def make_install
      src_dir = get_src_dir(@version)
      Dir.chdir src_dir do
        system("make all install #{@silent}")
      end
    end

    def self.cp_etc
      current_login = get_login_file
      path = File.join(File.dirname(__FILE__), '..', '..', 'etc', 'login')
      login = File.expand_path(path)
      if !File.exist?(current_login)
        etc_dir = get_etc_dir
        FileUtils.mkdir_p(etc_dir)
        FileUtils.cp(login, etc_dir)
      elsif !FileUtils.compare_file(login, current_login)
        FileUtils.cp(login, get_etc_dir)
      end
    end

    def message
      return if !$?.success? || @silent.empty?
      print "\e[32m"
      puts <<-EOS

  Vim is successfully installed.  For daily use,
  please add the following line into your ~/.bash_login etc:

  test -f ~/.vvm-rb/etc/login && source ~/.vvm-rb/etc/login

      EOS
      print "\e[0m"
    end
  end
end

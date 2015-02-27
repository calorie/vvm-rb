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
      FileUtils.mkdir_p(repos_dir)
      repo = vimorg_dir
      system("hg -q clone #{VIM_URI} #{repo}") unless File.exist?(repo)
    end

    def self.pull
      fetch unless File.exist?(vimorg_dir)
      Dir.chdir(vimorg_dir) { system('hg -q pull') }
    end

    def checkout
      src = src_dir
      FileUtils.mkdir_p(src)
      return if File.exist?(src_dir(@version))
      archive = "hg archive -t tar -r #{@version} -p #{@version} -"
      expand  = "(cd #{src} && tar xf -)"
      Dir.chdir vimorg_dir do
        system("#{archive} | #{expand} #{@silent}")
      end
    end

    def configure
      vims    = vims_dir(@version)
      src     = src_dir(@version)
      default = "--prefix=#{vims}"
      Dir.chdir src do
        system("./configure #{default} #{@conf.join(' ')} #{@silent}")
      end
    end

    def make_clean
      src = src_dir(@version)
      Dir.chdir src do
        system("make clean #{@silent}")
      end
    end

    def make_install
      src = src_dir(@version)
      Dir.chdir src do
        system("make all install #{@silent}")
      end
    end

    def self.cp_etc
      current_login = login_file
      path = File.join(File.dirname(__FILE__), '..', '..', 'etc', 'login')
      login = File.expand_path(path)
      if !File.exist?(current_login)
        etc = etc_dir
        FileUtils.mkdir_p(etc)
        FileUtils.cp(login, etc)
      elsif !FileUtils.compare_file(login, current_login)
        FileUtils.cp(login, etc_dir)
      end
    end

    def message
      return if !$?.success? || !@silent.empty?
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

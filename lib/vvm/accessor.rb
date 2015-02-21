module Vvm
  module Accessor
    module_function

    def dot_dir
      File.expand_path(ENV['VVMROOT'] || '~/.vvm-rb')
    end

    def etc_dir
      File.join(dot_dir, 'etc')
    end

    def repos_dir
      File.join(dot_dir, 'repos')
    end

    def src_dir(version = '')
      File.join(dot_dir, 'src', version)
    end

    def vims_dir(version = '')
      File.join(dot_dir, 'vims', version)
    end

    def vimorg_dir
      File.join(repos_dir, 'vimorg')
    end

    def login_file
      File.join(etc_dir, 'login')
    end

    def current_dir
      File.join(vims_dir, 'current')
    end
  end
end

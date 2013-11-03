module Accesser

  module_function

  def get_dot_dir
    File.expand_path(ENV['VVMROOT'] || '~/.vvm-rb')
  end

  def get_etc_dir
    File.join(get_dot_dir, 'etc')
  end

  def get_repos_dir
    File.join(get_dot_dir, 'repos')
  end

  def get_src_dir(version = '')
    File.join(get_dot_dir, 'src', version)
  end

  def get_vims_dir(version = '')
    File.join(get_dot_dir, 'vims', version)
  end

  def get_vimorg_dir
    File.join(get_repos_dir, 'vimorg')
  end

  def get_login_file
    File.join(get_etc_dir, 'login')
  end

  def get_current_dir
    File.join(get_vims_dir, 'current')
  end
end

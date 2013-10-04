require 'fileutils'

class Uninstaller
  def initialize(version)
    @version = version
  end

  def uninstall
    current  = get_current_dir
    vims_dir = get_vims_dir(@version)
    src_dir  = get_src_dir(@version)
    if Dir.exists?(current)
      target = File.readlink(current)
      if target == vims_dir
        abort "#{@version} can not be uninstalled; it is currently used."
      end
    end
    if Dir.exists?(src_dir)
      FileUtils.rm_rf(src_dir)
    end
    if Dir.exists?(vims_dir)
      FileUtils.rm_rf(vims_dir)
    end
  end
end

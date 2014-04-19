require 'fileutils'

class Uninstaller
  def initialize(version)
    @version = version
  end

  def uninstall
    current  = get_current_dir
    vims_dir = get_vims_dir(@version)
    src_dir  = get_src_dir(@version)
    if File.exist?(current)
      target = File.readlink(current)
      if target == vims_dir
        abort "#{@version} can not be uninstalled; it is currently used."
      end
    end
    FileUtils.rm_rf(src_dir) if File.exist?(src_dir)
    FileUtils.rm_rf(vims_dir) if File.exist?(vims_dir)
  end
end

require 'fileutils'

class Switcher
  def initialize(version)
    @version = version
  end

  def use
    current = get_current_dir
    if Dir.exists?(current)
      FileUtils.rm(current)
    end
    unless @version == 'system'
      vims_dir = get_vims_dir(@version)
      unless Dir.exists?(vims_dir)
        abort "#{@version} is not installed."
      end
      FileUtils.ln_s(vims_dir, current)
    end
  end
end

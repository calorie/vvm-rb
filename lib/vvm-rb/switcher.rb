require 'fileutils'

class Switcher
  def initialize(version)
    @version = version
  end

  def use
    current = get_current
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

  private

  def get_current
    return "#{VIMS_DIR}/current"
  end

  def get_vims_dir(version)
    return "#{VIMS_DIR}/#{version}"
  end
end

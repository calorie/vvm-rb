require 'fileutils'

class Switcher
  def initialize(version)
    @version = version
  end

  def use
    current = get_current_dir
    FileUtils.rm(current) if File.exists?(current)
    unless @version == 'system'
      vims_dir = get_vims_dir(@version)
      abort "#{@version} is not installed." unless File.exists?(vims_dir)
      FileUtils.ln_s(vims_dir, current)
    end
  end
end

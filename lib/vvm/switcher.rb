require 'fileutils'

module Vvm
  class Switcher
    def initialize(version)
      @version = version
    end

    def use
      current = current_dir
      FileUtils.rm(current) if File.exist?(current)
      return if @version == 'system'
      vims = vims_dir(@version)
      abort "#{@version} is not installed." unless File.exist?(vims)
      FileUtils.ln_s(vims, current)
    end
  end
end

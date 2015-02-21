require 'fileutils'

module Vvm
  class Uninstaller
    def initialize(version)
      @version = version
    end

    def uninstall
      abort "#{@version} can not be uninstalled; It is currently used." if used?
      vims = vims_dir(@version)
      src  = src_dir(@version)
      FileUtils.rm_rf(src) if File.exist?(src)
      FileUtils.rm_rf(vims) if File.exist?(vims)
    end

    private

    def used?
      current = current_dir
      return false unless File.exist?(current)
      File.readlink(current) == vims_dir(@version)
    end
  end
end

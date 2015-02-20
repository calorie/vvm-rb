module Vvm
  class Version
    def self.list
      Dir.chdir(get_vimorg_dir) do
        list = `hg tags`.split.reverse
        return list.values_at(* list.each_index.select { |i| i.odd? })
      end
    end

    def self.versions
      output   = []
      vims_dir = get_vims_dir
      return output unless File.exist?(vims_dir)
      Dir.glob(File.join(vims_dir, 'v*')).sort.each do |d|
        output << File.basename(d)
      end
      return output
    end

    def self.latest
      return list.select { |v| v =~ /\Av7-.+\z/ }.last
    end

    def self.current
      c = get_current_dir
      return File.exist?(c) ? File.basename(File.readlink(c)) : 'system'
    end

    def self.convert(version)
      return "v#{version.gsub(/\./, '-')}"
    end

    def self.format(version)
      case version
      when /\Alatest\z/
        version = latest
      when /\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
        version = convert(version)
      end
      return version
    end
  end
end

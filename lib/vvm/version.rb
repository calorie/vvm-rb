module Vvm
  class Version
    def self.list
      abort "#{vimorg_dir} not found." unless File.exist?(vimorg_dir)
      Dir.chdir(vimorg_dir) do
        list = `hg tags`.split.reverse
        return list.values_at(* list.each_index.select(&:odd?))
      end
    end

    def self.versions
      output = []
      vims   = vims_dir
      return output unless File.exist?(vims)
      Dir.glob(File.join(vims, 'v*')).sort.each do |d|
        output << File.basename(d)
      end
      output
    end

    def self.latest
      list.select { |v| v =~ /\Av7-.+\z/ }.last
    end

    def self.current
      d = current_dir
      File.exist?(d) ? File.basename(File.readlink(d)) : 'system'
    end

    def self.convert(version)
      "v#{version.gsub(/\./, '-')}"
    end

    def self.format(version)
      case version
      when /\Alatest\z/
        version = latest
      when /\A(\d\.\d(a|b){0,1}(\.\d+){0,1})\z/
        version = convert(version)
      end
      version
    end
  end
end

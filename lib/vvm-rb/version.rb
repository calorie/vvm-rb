class Version
  def self.list
    vimorg_dir = get_vimorg_dir
    return [] unless File.exists?(vimorg_dir)
    Dir.chdir(vimorg_dir) do
      list = `hg tags`.split.reverse
      return list.values_at(* list.each_index.select { |i| i.odd? })
    end
  end

  def self.versions
    output = []
    vims_dir = get_vims_dir
    return output unless File.exists?(vims_dir)
    Dir.glob(File.join(vims_dir, 'v*')).sort.each do |d|
      output << File.basename(d)
    end
    return output
  end
end

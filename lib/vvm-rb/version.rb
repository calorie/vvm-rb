class Version
  def self.list
    Dir.chdir(get_vimorg_dir) do
      list = `hg tags`.split.reverse
      return list.values_at(* list.each_index.select { |i| i.odd? })
    end
  end

  def self.versions
    output = []
    Dir.glob(File.join(get_vims_dir, 'v*')).sort.each do |d|
      output << File.basename(d)
    end
    return output
  end
end

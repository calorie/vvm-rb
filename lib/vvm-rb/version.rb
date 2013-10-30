class Version
  def initialize
    self.dot_dir = ENV['VVMROOT'] unless ENV['VVMROOT'].nil?
  end

  def list
    Dir.chdir(get_vimorg_dir) do
      list = `hg tags`.split.reverse
      return list.values_at(* list.each_index.select {|i| i.odd?}).join("\n")
    end
  end

  def versions
    output = []
    Dir.glob(File.join(get_vims_dir, 'v*')).sort.each{ |d| output << File.basename(d) }
    return output.join("\n")
  end
end

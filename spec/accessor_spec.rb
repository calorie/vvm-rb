require 'spec_helper'

describe 'Accessor' do
  it 'can access vvm-rb home directory' do
    expect(File.exist?(get_dot_dir)).to be_truthy
  end

  it 'can access etc directory' do
    expect(File.exist?(get_etc_dir)).to be_truthy
  end

  it 'can access repos directory' do
    expect(File.exist?(get_repos_dir)).to be_truthy
  end

  it 'can access src directory' do
    expect(File.exist?(get_src_dir)).to be_truthy
  end

  it 'can access vims directory' do
    expect(File.exist?(get_vims_dir)).to be_truthy
  end

  it 'can access vimorg directory' do
    expect(File.exist?(get_vimorg_dir)).to be_truthy
  end

  it 'can access login file' do
    expect(File.exist?(get_login_file)).to be_truthy
  end

  context 'of current directory' do
    before { Vvm::Switcher.new(VERSION1).use }
    after { Vvm::Switcher.new('system').use }

    it 'can access current directory' do
      expect(File.exist?(get_current_dir)).to be_truthy
    end
  end
end

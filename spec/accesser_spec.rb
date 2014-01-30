require 'spec_helper'

describe 'Accesser' do
  it 'can access vvm-rb home directory' do
    expect(File.exists?(get_dot_dir)).to be_true
  end

  it 'can access etc directory' do
    expect(File.exists?(get_etc_dir)).to be_true
  end

  it 'can access repos directory' do
    expect(File.exists?(get_repos_dir)).to be_true
  end

  it 'can access src directory' do
    expect(File.exists?(get_src_dir)).to be_true
  end

  it 'can access vims directory' do
    expect(File.exists?(get_vims_dir)).to be_true
  end

  it 'can access vimorg directory' do
    expect(File.exists?(get_vimorg_dir)).to be_true
  end

  it 'can access login file' do
    expect(File.exists?(get_login_file)).to be_true
  end

  context 'of current directory' do
    before { Switcher.new(VERSION1).use }
    after { Switcher.new('system').use }

    it 'can access current directory' do
      expect(File.exists?(get_current_dir)).to be_true
    end
  end
end

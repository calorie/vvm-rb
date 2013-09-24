require 'spec_helper'

describe 'Cli' do
  describe 'install' do
    let(:output) { capture(:stdout) { Cli.start('install v7-4-001'.split)} }

    it 'success' do
      expect(output).to match(/Vim is successfully installed/)
    end
  end

  describe 'reinstall' do
    let(:output) { capture(:stdout) { Cli.start('reinstall v7-4-001'.split)} }

    it 'success' do
      expect(output).to match(/Vim is successfully installed/)
    end
  end

  describe 'rebuild' do
    let(:output) { capture(:stdout) { Cli.start('rebuild v7-4-001'.split)} }

    it 'success' do
      expect(output).to match(/Vim is successfully rebuilded/)
    end
  end

  describe 'use' do
    let(:output) { capture(:stdout) { Cli.start('use v7-4'.split)} }

    it 'success' do
      expect(output).to eq('')
    end
  end

  describe 'uninstall' do
    let(:output) { capture(:stdout) { Cli.start('uninstall v7-3-969'.split)} }

    it 'success' do
      expect(output).to eq('')
    end
  end
end

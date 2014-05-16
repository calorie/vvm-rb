# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: vvm-rb 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "vvm-rb"
  s.version = "0.2.0"

  s.required_ruby_version = '>= 1.9'
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Yuu Shigetani"]
  s.date = "2014-05-16"
  s.description = "vim version manager."
  s.email = "s2g4t1n2@gmail.com"
  s.executables = ["vvm-rb"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".coveralls.yml",
    ".document",
    ".rspec",
    ".rubocop.yml",
    ".travis.yml",
    "Gemfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/vvm-rb",
    "etc/login",
    "lib/vvm-rb.rb",
    "lib/vvm-rb/accesser.rb",
    "lib/vvm-rb/base.rb",
    "lib/vvm-rb/cli.rb",
    "lib/vvm-rb/constants.rb",
    "lib/vvm-rb/installer.rb",
    "lib/vvm-rb/switcher.rb",
    "lib/vvm-rb/uninstaller.rb",
    "lib/vvm-rb/validator.rb",
    "lib/vvm-rb/version.rb",
    "spec/accesser_spec.rb",
    "spec/installer_spec.rb",
    "spec/spec_helper.rb",
    "spec/switcher_spec.rb",
    "spec/uninstaller_spec.rb",
    "spec/validator_spec.rb",
    "spec/version_spec.rb",
    "vvm-rb.gemspec"
  ]
  s.homepage = "http://github.com/calorie/vvm-rb"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "vim version manager"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14.1"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.21.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.1.1"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.8.2"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.7.0"])
    else
      s.add_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_dependency(%q<rspec>, ["~> 2.14.1"])
      s.add_dependency(%q<rubocop>, ["~> 0.21.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.1.1"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, ["~> 0.8.2"])
      s.add_dependency(%q<coveralls>, ["~> 0.7.0"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.19.1"])
    s.add_dependency(%q<rspec>, ["~> 2.14.1"])
    s.add_dependency(%q<rubocop>, ["~> 0.21.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.1.1"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, ["~> 0.8.2"])
    s.add_dependency(%q<coveralls>, ["~> 0.7.0"])
  end
end


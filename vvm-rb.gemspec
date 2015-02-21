# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: vvm-rb 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "vvm-rb"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Yuu Shigetani"]
  s.date = "2015-02-21"
  s.description = "vim version manager."
  s.email = "s2g4t1n2@gmail.com"
  s.executables = ["vvm"]
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
    "bin/vvm",
    "etc/login",
    "lib/vvm.rb",
    "lib/vvm/accessor.rb",
    "lib/vvm/cli.rb",
    "lib/vvm/constants.rb",
    "lib/vvm/ext/mkmf.rb",
    "lib/vvm/installer.rb",
    "lib/vvm/switcher.rb",
    "lib/vvm/uninstaller.rb",
    "lib/vvm/validator.rb",
    "lib/vvm/version.rb",
    "spec/accessor_spec.rb",
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
  s.required_ruby_version = Gem::Requirement.new(">= 1.9")
  s.rubygems_version = "2.4.5"
  s.summary = "vim version manager"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_development_dependency(%q<rspec>, ["~> 3.2"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.29.1"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.9.2"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.7.10"])
    else
      s.add_dependency(%q<thor>, ["~> 0.19.1"])
      s.add_dependency(%q<rspec>, ["~> 3.2"])
      s.add_dependency(%q<rubocop>, ["~> 0.29.1"])
      s.add_dependency(%q<rdoc>, ["~> 4.2"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.9.2"])
      s.add_dependency(%q<coveralls>, ["~> 0.7.10"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.19.1"])
    s.add_dependency(%q<rspec>, ["~> 3.2"])
    s.add_dependency(%q<rubocop>, ["~> 0.29.1"])
    s.add_dependency(%q<rdoc>, ["~> 4.2"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.9.2"])
    s.add_dependency(%q<coveralls>, ["~> 0.7.10"])
  end
end


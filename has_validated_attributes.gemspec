# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name = %q{has_validated_attributes}
  s.version = HasValidatedAttributes::VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kyle Ginavan"]
  s.date = %q{2010-05-18}
  s.homepage = "https://github.com/kylejginavan/has_validated_attributes"
  s.summary =  %q{Ruby on Rails gem for validate data prior to save}
  s.description = %q{has_validated_attributes is a Ruby on Rails gem that lets you validate your fields.}
  s.email = %q{kylejginavan@gmail.com}
  s.rubyforge_project = "has_validated_attributes"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec"
  s.add_development_dependency("activerecord", ['>= 3.1.0'])
  s.add_development_dependency("sqlite3")
  s.add_development_dependency('database_cleaner')
end


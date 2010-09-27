# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{plot_statistics}
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Asa Wilson"]
  s.date = %q{2010-09-27}
  s.description = %q{This is a gem to do a Ripley's K analysis}
  s.email = %q{acvwilson@gmail.com}
  s.executables = ["bivariate_ripleys_k", "univariate_ripleys_k"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "bin/bivariate_ripleys_k",
     "bin/univariate_ripleys_k",
     "lib/plot_statistics.rb",
     "lib/plot_statistics/circle.rb",
     "lib/plot_statistics/clam.rb",
     "lib/plot_statistics/clam_plot.rb",
     "lib/plot_statistics/monte_carlo.rb",
     "lib/plot_statistics/output.rb",
     "plot_statistics.gemspec",
     "spec/plot_statistics_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/acvwilson/plot_statistics}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{This is a gem to do a Ripley's K analysis}
  s.test_files = [
    "spec/plot_statistics_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<fastercsv>, [">= 1.5.0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<fastercsv>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<fastercsv>, [">= 1.5.0"])
  end
end


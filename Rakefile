# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  if ENV["TRAVIS"]
    Bundler.setup(:default, :test)
  else
    Bundler.setup(:default, :development)
  end
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "tealeaves"
    gem.homepage = "http://github.com/knaveofdiamonds/tealeaves"
    gem.license = "MIT"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "roland.swingler@gmail.com"
    gem.authors = ["Roland Swingler"]
    # dependencies defined in Gemfile
  end
  Jeweler::RubygemsDotOrgTasks.new

  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError => e
  $stderr.puts "Not loading standard development tasks."
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

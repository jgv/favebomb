# -*- encoding: utf-8 -*-
require File.expand_path('../lib/favebomb/version', __FILE__)

Gem::Specification.new do |s|

  s.name = "favebomb"
  s.version = Favebomb::VERSION
  s.author = "Jonathan Vingiano"
  s.email = "jgv@jonathanvingiano.com"
  s.homepage = "http://github.com/jgv/favebomb"
  s.rubyforge_project = "favebomb"
  s.summary = "Positive reinforcement"
  s.description = "Favorite Tweets from the command line"
  s.files = `git ls-files`.split("\n")
  s.require_paths = ['lib', 'bin']
  s.executables = ['favebomb']

  s.add_dependency 'oauth'
  s.add_dependency 'json'
  s.add_dependency 'colored'

end

# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_surplus/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-surplus'
  spec.version       = Legion::Extensions::CognitiveSurplus::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Cognitive Surplus'
  spec.description   = 'Cognitive surplus capacity modeling for brain-modeled agentic AI'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-surplus'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/LegionIO/lex-cognitive-surplus'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-cognitive-surplus'
  spec.metadata['changelog_uri']     = 'https://github.com/LegionIO/lex-cognitive-surplus'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/LegionIO/lex-cognitive-surplus/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-cognitive-surplus.gemspec Gemfile LICENSE README.md]
  end
  spec.require_paths = ['lib']
end

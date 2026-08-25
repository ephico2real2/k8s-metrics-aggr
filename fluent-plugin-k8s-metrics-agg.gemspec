lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name    = 'fluent-plugin-k8s-metrics-agg'
  spec.version = File.read('VERSION')
  spec.authors = ['Splunk Inc.']
  spec.email   = ['DataEdge@splunk.com']

  spec.summary       = %q{A fluentd input plugin that collects kubernetes cluster metrics.}
  spec.description   = %q{A fluentd input plugin that collects node and container metrics from a kubernetes cluster via kubeapiserver API.}
  spec.homepage      = 'https://github.com/splunk/fluent-plugin-k8s-metrics-agg'
  spec.license       = 'Apache-2.0'

  # DO NOT SHELL OUT TO git HERE, AND KEEP THIS FILE PURE ASCII. This gemspec is evaluated at
  # RUNTIME, not just at build time - bundler re-reads it on every `bundle exec` because the plugin
  # is a path: dependency. Two container deaths have come from that fact:
  #  1. `git ls-files` raises in the git-less runtime ("No such file or directory - git. Bundler
  #     cannot continue.") - hence Dir.glob below, same file list, no external process.
  #  2. A non-ASCII character in a COMMENT (an em dash, U+2014) killed fluentd's spawned worker:
  #     the worker process starts with an ASCII-8BIT default encoding, and bundler's gemspec read
  #     dies with "U+2014 from UTF-8 to ASCII-8BIT (Encoding::UndefinedConversionError)". The
  #     supervisor boots and --dry-run passes - only the worker respawn loop fails, so nothing
  #     short of a real PID-1 boot test catches it.
  all_files          = Dir.glob('{bin,lib,test,spec,features}/**/*').reject(&File.method(:directory?)) +
                       %w[README.md LICENSE Gemfile Gemfile.lock Rakefile VERSION
                          fluent-plugin-k8s-metrics-agg.gemspec].select { |f| File.exist?(f) }
  test_files, files  = all_files.partition { |f| f.match(%r{^(test|spec|features)/}) }
  spec.files         = files
  spec.executables   = files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = test_files
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'test-unit', "~> 3.3.0"
  spec.add_development_dependency "simplecov", '~> 0.16.1'
  spec.add_development_dependency 'webmock', '~> 3.5.1'
  spec.add_runtime_dependency 'fluentd', '>= 1.9.1'
  spec.add_runtime_dependency 'kubeclient', '~> 4.13'
  spec.add_runtime_dependency 'multi_json', '~> 1.14.1'
  spec.add_runtime_dependency 'oj', '~> 3.17'

end

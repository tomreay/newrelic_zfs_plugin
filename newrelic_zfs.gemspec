Gem::Specification.new do |s|
  s.name = 'newrelic_zfs'
  s.version = '0.0.1'
  s.date = '2014-01-04'
  s.summary = 'Newrelic ZFS'
  s.description = 'Newrelic plugin to monitor ZFS pools'
  s.authors = ['Tom Reay']
  s.email = 'dev@tomreay.co.uk'
  s.files = ['lib/newrelic_zfs.rb', 'lib/newrelic_zfs/config.rb']
  s.executables << 'newrelic_zfs'
  s.homepage = 'http://rubygems.org/gems/newrelic-zfs'
  s.license = 'MIT'
  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'newrelic_plugin'
  s.add_runtime_dependency 'trollop'
end
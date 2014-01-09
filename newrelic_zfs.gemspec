Gem::Specification.new do |s|
  s.name = 'newrelic_zfs'
  s.version = '1.0.0'
  s.date = '2014-01-04'
  s.summary = 'Newrelic ZFS'
  s.description = 'Newrelic plugin to monitor ZFS pools'
  s.authors = ['Tom Reay']
  s.email = 'dev@tomreay.co.uk'
  s.files = ['lib/newrelic_zfs.rb', 'lib/newrelic_zfs/config.rb']
  s.executables << 'newrelic_zfs'
  s.homepage = 'https://github.com/tomreay/newrelic_zfs_plugin'
  s.license = 'MIT'
  s.add_runtime_dependency 'bundler', '~> 1.5'
  s.add_runtime_dependency 'newrelic_plugin', '~> 1.3'
  s.add_runtime_dependency 'trollop', '~> 2.0'
end
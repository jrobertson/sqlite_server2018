Gem::Specification.new do |s|
  s.name = 'sqlite_server2018'
  s.version = '0.2.1'
  s.summary = 'Enables SQLite database access from a DRb server.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/sqlite_server2018.rb']
  s.add_runtime_dependency('sqlite3', '~> 1.3', '>=1.3.13')
  s.add_runtime_dependency('rxfhelper', '~> 0.8', '>=0.8.6')  
  s.add_runtime_dependency('hashcache', '~> 0.2', '>=0.2.10')  
  s.signing_key = '../privatekeys/sqlite_server2018.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/sqlite_server2018'
end

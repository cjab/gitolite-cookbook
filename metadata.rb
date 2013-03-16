name             'gitolite'
maintainer       'Chad Jablonski'
maintainer_email 'chad@dinocore.net'
license          'Apache 2.0'
description      'Installs/Configures gitolite'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
recipe "gitolite::default", "Installs and configures gitolite"
recipe "gitolite::install", "Installs and configures gitolite"
recipe "gitolite::repos",   "Configures gitolite users and repos"

name             'bugzilla'
maintainer       'Mathew Odden'
maintainer_email 'locke105@gmail.com'
license          'Apache License'
description      'Installs/Configures bugzilla'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'apache2'
depends 'database'
depends 'mysql'
depends 'perl'

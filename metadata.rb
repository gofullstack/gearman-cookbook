maintainer       "Cramer Development"
maintainer_email "sysadmin@cramerdev.com"
license          "Apache 2.0"
description      "Installs/Configures gearman libraries and server"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"
recipe           "gearman", "Install development libraries"
recipe           "gearman::server", "Install the Gearman job server"
recipe           "gearman::ruby_lib", "Install the Gearman Ruby client and worker libraries"

%w{ubuntu debian}.each do |os|
  supports os
end

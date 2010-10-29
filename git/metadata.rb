maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs git"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.9.0"
recipe            "git", "Installs git"
recipe            "git::utils", "Installs git additional utilities"

%w{ ubuntu debian arch redhat centos }.each do |os|
  supports os
end

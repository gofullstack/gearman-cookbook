maintainer        "Cramer Development, Inc."
maintainer_email  "sysadmin@cramerdev.com"
license           "Apache 2.0"
description       "Networking Utilities"
version           "0.0.1"

recipe "net-utils", "Installs network utilities"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end

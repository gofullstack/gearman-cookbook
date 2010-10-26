maintainer        "Cramer Development, Inc."
maintainer_email  "sysadmin@cramerdev.com"
license           "Apache 2.0"
description       "Base System Utilities"
version           "0.0.1"

recipe "sys-utils", "Installs base sytesm utilities"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end

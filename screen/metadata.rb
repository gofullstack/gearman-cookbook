maintainer        "Cramer Development, Inc."
maintainer_email  "sysadmin@cramerdev.com"
license           "Apache 2.0"
description       "Sets up an ntp client and the time zone"
version           "0.0.1"

recipe "time", "Sets up an ntp client and the time zone"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end

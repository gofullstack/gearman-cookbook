maintainer        "Cramer Development, Inc."
maintainer_email  "sysadmin@cramerdev.com"
license           "Apache 2.0"
description       "Sets up ntp client and time zone"
version           "0.0.1"

recipe "time", "Sets up ntp client and time zone"

%w{ redhat centos ubuntu debian }.each do |os|
  supports os
end

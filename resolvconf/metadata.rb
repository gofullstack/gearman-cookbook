maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Configures resolvconf"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.8.2"

recipe "resolvconf", "Configures resolvconf via attributes"

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "resolvconf",
  :display_name => "resolvconf",
  :description => "Hash of resolvconf attributes",
  :type => "hash"

attribute "resolvconf/search",
  :display_name => "resolvconf Search",
  :description => "Default domain to search"

attribute "resolvconf/nameservers",
  :display_name => "resolvconf Nameservers",
  :description => "Default nameservers",
  :type => "array",
  :default => ["8.8.8.8", "8.8.4.4"] # Google's


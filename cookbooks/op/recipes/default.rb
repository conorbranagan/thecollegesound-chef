package 'ntp'
package 'sysstat'

hostname = node[:op][:hostname]

file '/etc/hostname' do
  content "#{hostname}\n"
end

service 'hostname' do
  action :restart
end

file '/etc/hosts' do
  content "127.0.0.1 localhost #{hostname}\n"
end

user node[:thecollegesound][:owner_uid] do
  uid 1000
  gid "users"
  home "/home/thecollegesound"
  shell "/bin/bash"
  password "$1$lJNEo7y7$cKnP4rS04ObeMvsYhcBt4."
  supports :manage_home => true
end
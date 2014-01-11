package "vim"
package "ack-grep"

workspace_user = node['workspace']['owner']

# User is vagrant
directory "/home/#{workspace_user}" do
  owner workspace_user
  mode "0711"
end

# Do not bother me with ssh key checking
cookbook_file "ssh_config" do
  path "/home/#{workspace_user}/.ssh/config"
  action :create
  owner workspace_user
  mode "0400"
end

# Create our basic environment.

cookbook_file "/home/#{workspace_user}/.vimrc" do
  source "vimrc"
  mode 0644
  owner workspace_user
  group workspace_user
end

directory "/home/#{workspace_user}/.vim" do
  mode 0755
  owner workspace_user
  group workspace_user
  action :create
end

directory "/home/#{workspace_user}/.vim/doc" do
  mode 0755
  owner workspace_user
  group workspace_user
  action :create
end

directory "/home/#{workspace_user}/.vim/nerdtree_plugin" do
  mode 0755
  owner workspace_user
  group workspace_user
  action :create
end

directory "/home/#{workspace_user}/.vim/plugin" do
  mode 0755
  owner workspace_user
  group workspace_user
  action :create
end

cookbook_file "/home/#{workspace_user}/.vim/doc/bufexplorer.txt" do
  source "bufexplorer.txt"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.bash_profile" do
  source "bash_profile.sh"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.bashrc" do
  source "bashrc.sh"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.bash_aliases" do
  source "bash_aliases.sh"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.screenrc" do
  source "screenrc"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.vim/doc/NERD_tree.txt" do
  source "NERD_tree.txt"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.vim/nerdtree_plugin/exec_menuitem.vim" do
  source "exec_menuitem.vim"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.vim/nerdtree_plugin/fs_menu.vim" do
  source "fs_menu.vim"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.vim/plugin/bufexplorer.vim" do
  source "bufexplorer.vim"
  mode 0644
  owner workspace_user
  group workspace_user
end

cookbook_file "/home/#{workspace_user}/.vim/plugin/NERD_tree.vim" do
  source "NERD_tree.vim"
  mode 0644
  owner workspace_user
  group workspace_user
end

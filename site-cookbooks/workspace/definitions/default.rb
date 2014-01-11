define :python_project do
  project = params[:name]
  before_setup = params[:before_setup]
  project_dir = "#{node.workspace.dir}/#{project}"
  execute "clone git project" do
    command "git clone git@github.com:DataDog/#{project}.git #{project_dir}"
    user node.workspace.owner
    creates project_dir
  end

  if before_setup
    script "before-setup" do
      code before_setup
      interpreter "bash"
      user node.workspace.owner
      cwd project_dir
    end
  end

  script "setup-project" do
    code "source #{node.workspace.python_dir}/bin/activate && python setup.py develop"
    interpreter "bash"
    user node.workspace.owner
    cwd project_dir
  end
end

define :user_env do
  user = params[:user]
  var_name = params[:variable]
  value = params[:value]
  bash_line = "export #{var_name}=#{value}"
  bash_file = "/home/#{user}/.bash_profile"

  # FIXME: chef doesn't set $HOME to be the home for the user we're running as.
  bash "Set environment variable #{var_name} to #{value}" do
    code "echo \"\n#{bash_line}\" >> #{bash_file}"
    not_if "grep #{bash_line} #{bash_file}"
    user node[:workspace][:owner]
  end
end

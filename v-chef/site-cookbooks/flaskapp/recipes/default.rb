#
# this was helpful: https://github.com/otsuarez/flask2aws
#                   https://developer.github.com/guides/managing-deploy-keys/
#
package "git"
package "python-setuptools"  # for easy_install

conf_dir = node[:apache][:conf_enabled_dir] || "#{node[:apache][:dir]}/conf.d"

# make a home for our flask application
directory "/var/www/flask/appstack" do
	  owner node[:apache][:owner]
	  group node[:apache][:group]
	  mode "0755"
	  recursive true
	  action :create
end

# make a home for our git pull and credentials files 
directory "/tmp/.appstack_deploy/.ssh" do
	  owner node[:apache][:owner]
	  group node[:apache][:group]
	  recursive true
end

# clone the repo to /tmp so we can get at the files
### deploy "/tmp/.appstack_deploy/" do
### 	repo "git@github.com:CAEN/operdata.git"
### 	git_ssh_wrapper "wrap-ssh4git.sh" # sigh...
### end

# install flask with easy_install
execute "install_flask" do
	command "easy_install flask"
	user "root"
end

# install plotly with easy_install
execute "install_plotly" do
	command "easy_install plotly"
	user "root"
end

# copy a file from the chef config; this should be deleted
cookbook_file "#{conf_dir}/flask-virthost.conf" do
	source "flask-virthost.conf"
	mode "0644"
end

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
	  owner "root"
	  group "root"
	  mode "0755"
	  recursive true
	  action :create
end

cookbook_file "/tmp/.appstack_deploy/.ssh/deployKey" do
	  source "deployKey"
	  owner "root"
	  mode 0600
end

cookbook_file "/tmp/.appstack_deploy/wrap-ssh4git.sh" do
	  source "wrap-ssh4git.sh"
	  owner "root"
	  mode 0755
end

# clone the repo to /tmp so we can get at the files
git "/var/www/flask/appstack" do
	repo "git@bitbucket.org:acaird/operdata.git"
	user "root"
	action :checkout
	ssh_wrapper "/tmp/.appstack_deploy/wrap-ssh4git.sh"
end

#deploy "/tmp/.appstack_deploy/" do
#	repo "git@bitbucket.org:acaird/operdata.git"
#	ssh_wrapper "/tmp/.appstack_deploy/wrap-ssh4git.sh"
#end

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

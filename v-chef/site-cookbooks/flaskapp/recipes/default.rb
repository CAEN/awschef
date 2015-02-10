package "git"
package "python-setuptools"  # for easy_install

conf_dir = node[:apache][:conf_enabled_dir] || "#{node[:apache][:dir]}/conf.d"

# make a home for our flask application
directory "/var/www/flask/appstack" do
	  owner "ubuntu"
	  group "root"
	  mode "0755"
	  action :create
end

# make a home for our git pull
directory "/tmp/.appstack_deploy/.ssh" do
	  owner "ubuntu"
	  recursive true
end

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

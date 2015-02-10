package "git"
package "python-setuptools"  # for easy_install

conf_dir = node[:apache][:conf_enabled_dir] || "#{node[:apache][:dir]}/conf.d"

execute "install_flask" do
	command "easy_install flask"
	user "root"
end

execute "install_plotly" do
	command "easy_install plotly"
	user "root"
end

cookbook_file "#{conf_dir}/flask-virthost.conf" do
	source "flask-virthost.conf"
	mode "0644"
end

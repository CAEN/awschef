package "git"

conf_dir = node[:apache][:conf_enabled_dir] || "#{node[:apache][:dir]}/conf.d"

cookbook_file "#{conf_dir}/flask-virthost.conf" do
	source "flask-virthost.conf"
	mode "0644"
end

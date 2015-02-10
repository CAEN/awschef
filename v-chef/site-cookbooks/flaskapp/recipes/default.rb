package "git"

cookbook_file "/etc/apache2/conf-available/flask-virthost.conf" do
	source "flask-virthost.conf"
	mode "0644"
end

link "/etc/apache2/conf-enabled/flask-virthost.conf" do
	to "../conf-available/flask-virthost.conf" 
end

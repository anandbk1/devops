package "apache2" do
	action :install
end

service "apache2" do
	action :start
end

packages = ['mysql-server','mysql-client','php','libapache2-mod-php','php-mcrypt','php-mysql'] 
packages.each do |package|
	apt_package package do
		action :install
	end
end

execute "reset mysqladmin root password" do
	command 'mysqladmin -u root password rootpassword'
end

remote_file "downloading below sqm commands file" do
	source 'https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/mysqlcommands'
	path '/tmp/myslcommands'
end

execute "mysql -uroot -prootpassword < /tmp/mysqlcommands" do
	command 'mysql -uroot -prootpassword < /tmp/mysqlcommands'
end

remote_file "Download wordpress" do
	source 'https://wordpress.org/latest.zip'
	path  'tmp/latest.zip'
end

package "Installing unzip" do
	package_name 'unzip'
	action :install
end

execute "unzipping latest to html folder" do
	command 'sudo unzip /tmp/latest.zip -d /var/www/html'
end

remote_file "Downloading wp-config.php" do
	source 'wget https://gitlab.com/roybhaskar9/devops/raw/master/coding/chef/chefwordpress/files/default/wp-config-sample.php'
	path '/tmp/wp-config-sample.php'
end

file 'copying wp-config-sample.php" do
     content IO.read('/tmp/wp-config-sample.php')
	 path 'var/www/html/wordpress/wp-config.php'
	 action :create

execute "copying to wordpress folder" do
	command 'cp wp-config-sample.php /var/www/html/wordpress/wp-config-sample.php'
	
end

execute "setting permission on wordpress folder" do
	command 'sudo chmod -R 775 /var/www/html/wordpress'
end

execute "Change permission on folder" do
	command 'sudo chown -R www-data:www-data /var/www/html/wordpress'
end

execute "sudo service apache2 restart" do
	command 'sudo service apache2 restart'
end
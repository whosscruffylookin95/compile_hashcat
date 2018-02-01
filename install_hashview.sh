#!/bin/bash
sudo apt update
sudo apt install git mysql-server libmysqlclient-dev redis-server openssl ruby ruby-dev
sudo mysql_secure_installation

sudo echo "[mysqld]" >> /etc/mysql/conf.d/hashview.cnf
sudo echo "innodb_flush_log_at_trx_commit  = 0" >> /etc/mysql/conf.d/hashview.cnf
sudo echo "innodb_file_format = Barracuda" >> /etc/mysql/conf.d/hashview.cnf
sudo echo "innodb_large_prefix = 1" >> /etc/mysql/conf.d/hashview.cnf
sudo echo "innodb_file_per_table=true" >> /etc/mysql/conf.d/hashview.cnf

sudo service mysql restart

cd
git clone https://github.com/hashview/hashview
cd hashview

sed -i -e "s/ruby '2.2.2'/ruby '2.3.1'/g" Gemfile

gem install bundler
bundle install


cp config/database.yml.example config/database.yml
nano config/database.yml

RACK_ENV=production rake db:setup

sed -i -e 's/"hc_binary_path": ""/"hc_binary_path": "\/usr\/local\/bin\/hashcat"/g' config/agent_config.json

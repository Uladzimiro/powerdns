sudo apt-get -y update
sudo apt-get -y upgrade

# PostgreSQL 12
# sudo -H bash -i -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo -H bash -i -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql-12 postgresql-contrib-12

sudo -u postgres createuser pdns -s
sudo -u postgres psql postgres -c "ALTER USER pdns WITH ENCRYPTED PASSWORD 'pdns'" 
sudo -u postgres createdb pdns
sudo -u postgres psql pdns < /vagrant/pdns_pg_schema.sql
sudo -H -u postgres bash -i -c 'echo "local   pdns            pdns                                    md5" >> /etc/postgresql/12/main/pg_hba.conf '
sudo -H -u postgres bash -i -c 'echo "host    pdns            pdns            127.0.0.1/32            md5" >> /etc/postgresql/12/main/pg_hba.conf '
sudo systemctl restart postgresql

# PowerDNS 4.2 - for some reason it installs 4.1 on 18.04, but 4.2 on 16.04 !?!?
# sudo -H bash -i -c 'echo "deb [arch=amd64] http://repo.powerdns.com/ubuntu bionic-rec-42 main" > /etc/apt/sources.list.d/pdns.list'
sudo -H bash -i -c 'echo "deb [arch=amd64] http://repo.powerdns.com/ubuntu xenial-auth-42 main" > /etc/apt/sources.list.d/pdns.list'
sudo -H bash -i -c 'echo "Package: pdns-*" >> /etc/apt/preferences.d/pdns'
sudo -H bash -i -c 'echo "Pin: origin repo.powerdns.com" >> /etc/apt/preferences.d/pdns'
sudo -H bash -i -c 'echo "Pin-Priority: 600" >> /etc/apt/preferences.d/pdns'
wget --quiet -O - https://repo.powerdns.com/FD380FBB-pub.asc | sudo apt-key add -
sudo apt-get update

sudo apt-get -y install pdns-server
sudo apt-get -y install pdns-backend-pgsql

# # https://mindwatering.com/SupportRef.nsf/webpg/447007D14637FFBC8525836E006DA217
# # https://computingforgeeks.com/install-powerdns-and-powerdns-admin-on-ubuntu-18-04-debian-9-mariadb-backend/
sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved

sudo mv /etc/powerdns/pdns.conf /etc/powerdns/pdns.conf.old
sudo cp /vagrant/pdns.conf /etc/powerdns/pdns.conf

# sudo mv /etc/powerdns/pdns.d/pdns.local.gpgsql.conf /etc/powerdns/pdns.d/pdns.local.gpgsql.conf.old
#sudo mv -f /etc/powerdns/pdns.d/pdns.gpgsql.conf /etc/powerdns/pdns.d/pdns.gpgsql.conf.old
sudo cp /vagrant/pdns.gpgsql.conf /etc/powerdns/pdns.d/pdns.gpgsql.conf

sudo systemctl restart pdns

# dig chaos txt version.bind @127.0.0.1 +short
# sudo tail -f /var/log/syslog

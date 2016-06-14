#!/bin/bash

# Install postgresql
apt-get install -y postgresql-9.3 postgresql-contrib-9.3 postgresql-client-9.3 libpq-dev

# Set password for postgres database user
sudo -u postgres psql postgres postgres -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'password'"

# allow all users to access postgres locally from any user
rm /etc/postgresql/9.3/main/pg_hba.conf
echo "local   all             all                                     md5"|sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
echo "local   all             postgres                                peer"|sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
echo "local   all             all                                     peer"|sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
echo "host    all             all             127.0.0.1/32            md5"|sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
echo "host    all             all             ::1/128                 md5"|sudo tee --append /etc/postgresql/9.3/main/pg_hba.conf
service postgresql restart
#!/bin/bash

# Install ruby and rails
apt-get install -y git-core curl zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties make libv8-dev libqt4-dev

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
cd ~/.rbenv && src/configure && make -C src

echo $PATH

# Add rbenv paths and eval to .bashrc and .bash_profile (needed in login/non-login shells)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"\neval "$(rbenv init -)"' | tee --append ~/.bash_profile ~/.bashrc
echo 'export BUNDLE_PATH="~/bundle"' >> /etc/profile.d/bundle.sh
. ~/.bash_profile

echo $PATH

# Install rbenv plugns
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
git clone git://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
git clone git://github.com/dcarley/rbenv-sudo.git ~/.rbenv/plugins/rbenv-sudo

# Install and set default ruby version
cd ~/.rbenv
rbenv install --keep 2.1.6
rbenv global 2.1.6
. ~/.bash_profile
ruby -v
echo -e "install: --no-ri --no-rdoc\nupdate: --no-ri --no-rdoc" > ~/.gemrc

# Install bundler
gem install bundler

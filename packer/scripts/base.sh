#!/usr/bin/env bash
set -e

#Install pre-requisite packages
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y bind-utils nginx nodejs
yum groupinstall -y development
yum -y update

# Install ruby version manager and set alias directory 
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.4.2
rvm alias create simple-sinatra-app ruby-2.4.2
gem update --system
echo "Ruby gem installs will take a while (bundler rails)..."
gem install bundler rails
echo "Ruby gem installs will take a while (unicorn)..."
gem install unicorn
echo "Ruby gem installs will take a while (sinatra)..."
gem install sinatra

echo "End of base packages installation"


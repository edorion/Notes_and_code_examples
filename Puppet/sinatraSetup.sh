#!/bin/bash

#Created by Andrew McDonald
#note: There are other ways to have achieved what this does but:
#1. I wanted to submit some part of this as a script (apache config can be managed via apache module)
#2. I was having issues with vcsdeploy to run "bundle install"
#It's a touch dirty but it is what it is.

#create virt host directory config for rack app
if ! grep -iq sinatra /etc/apache2/sites-available/default; then
        sed -i "/<\/VirtualHost>/i\\
        RackBaseURI /sinatra  \\
        <Directory /var/www/sinatra>  \\
                Options -MultiViews  \\
        </Directory> \\
        " /etc/apache2/sites-available/default
fi

#check for and create/clone app code
if ! ls /data/ | grep -q sinatra; then
        mkdir /data
        git clone git://github.com/tnh/simple-sinatra-app.git /data/sinatra
        mkdir /data/sinatra/public
        cd /data/sinatra/
        bundle install
fi

#link data folder to apach root
if ! ls /var/www/ | grep -q sinatra; then
        ln -s /data/sinatra/public /var/www/sinatra
fi

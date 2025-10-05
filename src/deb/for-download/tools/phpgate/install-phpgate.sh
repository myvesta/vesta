#!/bin/bash

echo "== Running: apt-get update"
release=$(cat /etc/debian_version | tr "." "\n" | head -n1)
if [ "$release" -lt 10 ]; then
    apt-get update
else
    apt-get update --allow-releaseinfo-change
fi


installed_memcache=0;
count=$(systemctl list-unit-files |  grep -c 'memcached\.service.*enabled')
if [ $count -gt 0 ]; then
    installed_memcache=1;
fi

if [ $installed_memcache -eq 0 ]; then
    echo "== Installing memcached"
    memory=$(grep 'MemTotal' /proc/meminfo |tr ' ' '\n' |grep [0-9])
    apt-get -y install memcached 
    if [ $memory -lt 15000000 ]; then
        sed -i "s/-m 64/-m 256/" /etc/memcached.conf
    else
        sed -i "s/-m 64/-m 1024/" /etc/memcached.conf
    fi
    systemctl restart memcached
    echo "== memcached installed."
fi

if [ -f "/etc/apt/trusted.gpg.d/php.gpg" ]; then
    echo "== renewing sury.org gpg key"
    wget -nv -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
fi

echo "== Installing php-memcached modules, please wait..."
apt-get install $(systemctl --full --type service --all | grep "php...-fpm" | sed 's#●##g' | awk '{print $1}' | cut -c1-6 | xargs -n 1 printf "%s-memcache ")
apt-get install $(systemctl --full --type service --all | grep "php...-fpm" | sed 's#●##g' | awk '{print $1}' | cut -c1-6 | xargs -n 1 printf "%s-memcached ")


echo "== Installing phpgate scripts"
mkdir -p /usr/share/phpgate
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate.php -O /usr/share/phpgate/phpgate.php
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate-func.php -O /usr/share/phpgate/phpgate-func.php
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate-agent-strings.php -O /usr/share/phpgate/phpgate-agent-strings.php

find /home/*/conf/web/ -type f \( -name "apache2.conf" -or -name "sapache2.conf" -or -name "*.apache2.conf" -or -name "*.apache2.ssl.conf" \) -exec grep open_basedir {} \; > /root/openbasedir.log

file=/etc/php5/apache2/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service apache2 restart
        # echo "apache2 restart result: $?"
    fi
fi

file=/etc/php/5.6/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php5.6-fpm restart
        # echo "php5.6-fpm restart result: $?"
    fi
fi

file=/etc/php/7.0/apache2/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service apache2 restart
        # echo "apache2 restart result: $?"
    fi
fi

file=/etc/php/7.0/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php7.0-fpm restart
        # echo "php7.0-fpm restart result: $?"
    fi
fi

file=/etc/php/7.1/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php7.1-fpm restart
        # echo "php7.1-fpm restart result: $?"
    fi
fi

file=/etc/php/7.2/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php7.2-fpm restart
        # echo "php7.2-fpm restart result: $?"
    fi
fi

file=/etc/php/7.3/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php7.3-fpm restart
        # echo "php7.3-fpm restart result: $?"
    fi
fi

file=/etc/php/7.4/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php7.4-fpm restart
        # echo "php7.4-fpm restart result: $?"
    fi
fi

file=/etc/php/8.0/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php8.0-fpm restart
        # echo "php8.0-fpm restart result: $?"
    fi
fi

file=/etc/php/8.1/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php8.1-fpm restart
        # echo "php8.1-fpm restart result: $?"
    fi
fi

file=/etc/php/8.2/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php8.2-fpm restart
        # echo "php8.2-fpm restart result: $?"
    fi
fi

file=/etc/php/8.3/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php8.3-fpm restart
    fi
fi

file=/etc/php/8.4/fpm/php.ini
if [ -f "$file" ]; then
    # grep open_basedir $file
    if [ -z "$(grep phpgate $file)" ]; then
        sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
        grep phpgate $file
        service php8.4-fpm restart
    fi
fi

echo "== Done, phpgate installed."

exit 0

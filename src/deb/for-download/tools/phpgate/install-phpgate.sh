#!/bin/bash

/usr/local/vesta/bin/v-commander 'u'

if [ -f "/etc/apt/trusted.gpg.d/php.gpg" ]; then
    /usr/local/vesta/bin/v-commander 's'
fi

count=$(systemctl list-unit-files |  grep -c 'memcached\.service.*enabled')
if [ $count -eq 0 ]; then
    /usr/local/vesta/bin/v-commander 'inst memcached'
fi

echo "== Installing phpgate scripts"
mkdir -p /usr/share/phpgate
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate.php -O /usr/share/phpgate/phpgate.php
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate-func.php -O /usr/share/phpgate/phpgate-func.php
wget -nv https://c.myvestacp.com/tools/phpgate/phpgate-agent-strings.php -O /usr/share/phpgate/phpgate-agent-strings.php

# Deprecated:
# find /home/*/conf/web/ -type f \( -name "apache2.conf" -or -name "sapache2.conf" -or -name "*.apache2.conf" -or -name "*.apache2.ssl.conf" \) -exec grep open_basedir {} \; > /root/openbasedir.log

fix_php_ini() {
    file=$1
    if [ "$1" != "/etc/php5/apache2/php.ini" ]; then
        version=$(echo $file | grep -o '[0-9]\.[0-9]' | head -n1)
    fi
    if [ -f "$file" ]; then
        if [ -z "$(grep phpgate $file)" ]; then
            sed -i "s|auto_prepend_file =|auto_prepend_file = /usr/share/phpgate/phpgate.php|g" $file
            echo "= Fixing $file"
            grep 'phpgate' $file
            if [ "$1" = "/etc/php5/apache2/php.ini" ]; then
                systemctl restart apache2
            else
                systemctl restart php${version}-fpm
            fi
        fi
    fi
}

# Fix apache2 php.ini
fix_php_ini "/etc/php5/apache2/php.ini"

# Fix php-fpm php.ini
php_versions=$(/usr/local/vesta/bin/v-list-php)
for version in $php_versions; do
    fix_php_ini "/etc/php/${version}/fpm/php.ini"
done

echo "== Done, phpgate installed."

exit 0

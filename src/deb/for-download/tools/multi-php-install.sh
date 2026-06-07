#!/bin/bash

#########################################################################
# First enter 1 below for desired PHP versions and then run this script #
#########################################################################

inst_56=0
inst_70=0
inst_71=0
inst_72=0
inst_73=0
inst_74=0
inst_80=0
inst_81=0
inst_82=0
inst_83=0
inst_84=0
inst_85=0

#######################################################################

check_grep=$(grep -c "WEB_SYSTEM='nginx'" /usr/local/vesta/conf/vesta.conf)
if [ "$check_grep" -eq 1 ]; then
    echo "Multi-PHP support is only for myVesta that is installed in nginx+Apache or Apache variant"
    exit 1
fi

inst_repo=0
debian_version=$(cat /etc/debian_version | tr "." "\n" | head -n1)
memory=$(grep 'MemTotal' /proc/meminfo |tr ' ' '\n' |grep [0-9])

if [ $# -gt 0 ]; then
    inst_repo=$1
fi
if [ $# -gt 1 ]; then
    inst_56=$2
fi
if [ $# -gt 2 ]; then
    inst_70=$3
fi
if [ $# -gt 3 ]; then
    inst_71=$4
fi
if [ $# -gt 4 ]; then
    inst_72=$5
fi
if [ $# -gt 5 ]; then
    inst_73=$6
fi
if [ $# -gt 6 ]; then
    inst_74=$7
fi
if [ $# -gt 7 ]; then
    inst_80=$8
fi
if [ $# -gt 8 ]; then
    inst_81=$9
fi
if [ $# -gt 9 ]; then
    inst_82=${10}
fi
if [ $# -gt 10 ]; then
    inst_83=${11}
fi
if [ $# -gt 11 ]; then
    inst_84=${12}
fi
if [ $# -gt 12 ]; then
    inst_85=${13}
fi

if [ $inst_56 -eq 1 ] || [ $inst_70 -eq 1 ] || [ $inst_71 -eq 1 ] || [ $inst_72 -eq 1 ] || [ $inst_73 -eq 1 ] || [ $inst_74 -eq 1 ] || [ $inst_80 -eq 1 ] || [ $inst_81 -eq 1 ] || [ $inst_82 -eq 1 ] || [ $inst_83 -eq 1 ] || [ $inst_84 -eq 1 ] || [ $inst_85 -eq 1 ]; then
    inst_repo=1
fi

wait_to_press_enter=0
if [ -f "/root/wait_to_press_enter" ]; then
  wait_to_press_enter=1
fi

function press_enter {
    if [ $wait_to_press_enter -eq 1 ]; then
        read -p "$1"
    else
        echo $1
    fi
}


# echo "parameters=$#"
echo "debian_version=$debian_version"
echo "inst_repo=$inst_repo"
echo "inst_56=$inst_56"
echo "inst_70=$inst_70"
echo "inst_71=$inst_71"
echo "inst_72=$inst_72"
echo "inst_73=$inst_73"
echo "inst_74=$inst_74"
echo "inst_80=$inst_80"
echo "inst_81=$inst_81"
echo "inst_82=$inst_82"
echo "inst_83=$inst_83"
echo "inst_84=$inst_84"
echo "inst_85=$inst_85"
echo "wait_to_press_enter=$wait_to_press_enter"

press_enter "=== Press enter to continue ==============================================================================="

apt update
if [ "$inst_repo" -eq 1 ]; then
    press_enter "=== Press enter to install sury.org repo ==============================================================================="
    apt -y install apt-transport-https ca-certificates
    if [ $debian_version -ge 11 ]; then
      wget -nv -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    fi
    # if [ $debian_version -eq 10 ]; then
    #   sh -c 'echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list'
    # fi
    if [ $debian_version -eq 11 ]; then
      sh -c 'echo "deb https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list'
    fi
    if [ $debian_version -eq 12 ]; then
      sh -c 'echo "deb https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list'
    fi
    if [ $debian_version -eq 13 ]; then
      sh -c 'echo "deb https://packages.sury.org/php/ trixie main" > /etc/apt/sources.list.d/php.list'
    fi
    apt-get update
    # apt upgrade -y
    press_enter "=== Press enter to continue ==============================================================================="
fi

echo "=== Enabling proxy_fcgi setenvif"
a2enmod proxy_fcgi setenvif
service apache2 restart


if [ "$inst_56" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 5.6 ==============================================================================="
    apt-get -y install php5.6-mbstring php5.6-bcmath php5.6-cli php5.6-curl php5.6-fpm php5.6-gd php5.6-intl php5.6-mcrypt php5.6-mysql php5.6-soap php5.6-xml php5.6-zip php5.6-memcache php5.6-memcached php5.6-imagick
    update-rc.d php5.6-fpm defaults
    a2enconf php5.6-fpm
    systemctl restart apache2
    cp -r /etc/php/5.6/ /root/vst_install_backups/php5.6/
    # rm -f /etc/php/5.6/fpm/pool.d/*
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-56.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-56.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-56.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-56.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-56.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-56.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-56.sh
    mkdir -p /root/vesta-temp-dl/vesta/patch
    wget -nv https://c.myvestacp.com/tools/patches/php5.6.patch -O /root/vesta-temp-dl/vesta/patch/php5.6.patch
    patch -p1 --directory=/ < /root/vesta-temp-dl/vesta/patch/php5.6.patch
    rm -rf /root/vesta-temp-dl
    press_enter "=== Press enter to continue ==============================================================================="
fi

if [ "$inst_70" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 7.0 ==============================================================================="
    apt-get -y install php7.0-mbstring php7.0-bcmath php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-intl php7.0-mcrypt php7.0-mysql php7.0-soap php7.0-xml php7.0-zip php7.0-memcache php7.0-memcached php7.0-imagick
    update-rc.d php7.0-fpm defaults
    a2enconf php7.0-fpm
    systemctl restart apache2
    cp -r /etc/php/7.0/ /root/vst_install_backups/php7.0/
    # rm -f /etc/php/7.0/fpm/pool.d/*
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-70.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-70.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-70.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-70.sh
    if [ $debian_version -eq 9 ]; then
      cp /etc/php/7.0/apache2/php.ini /etc/php/7.0/fpm/php.ini
    fi
    if [ $debian_version -eq 10 ]; then
      cp /etc/php/7.3/fpm/php.ini /etc/php/7.0/fpm/php.ini
    fi
    if [ $debian_version -eq 11 ]; then
      cp /etc/php/7.4/fpm/php.ini /etc/php/7.0/fpm/php.ini
    fi
    press_enter "=== Press enter to continue ==============================================================================="
fi

if [ "$inst_71" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 7.1 ==============================================================================="
    apt-get -y install php7.1-mbstring php7.1-bcmath php7.1-cli php7.1-curl php7.1-fpm php7.1-gd php7.1-intl php7.1-mcrypt php7.1-mysql php7.1-soap php7.1-xml php7.1-zip php7.1-memcache php7.1-memcached php7.1-imagick
    update-rc.d php7.1-fpm defaults
    a2enconf php7.1-fpm
    systemctl restart apache2
    cp -r /etc/php/7.1/ /root/vst_install_backups/php7.1/
    # rm -f /etc/php/7.1/fpm/pool.d/*
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-71.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-71.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-71.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-71.sh
    if [ $debian_version -eq 9 ]; then
      cp /etc/php/7.0/apache2/php.ini /etc/php/7.1/fpm/php.ini
    fi
    if [ $debian_version -eq 10 ]; then
      cp /etc/php/7.3/fpm/php.ini /etc/php/7.1/fpm/php.ini
    fi
    if [ $debian_version -eq 11 ]; then
      cp /etc/php/7.4/fpm/php.ini /etc/php/7.1/fpm/php.ini
    fi
    press_enter "=== Press enter to continue ==============================================================================="
fi

if [ "$inst_72" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 7.2 ==============================================================================="
    apt-get -y install php7.2-mbstring php7.2-bcmath php7.2-cli php7.2-curl php7.2-fpm php7.2-gd php7.2-intl php7.2-mysql php7.2-soap php7.2-xml php7.2-zip php7.2-memcache php7.2-memcached php7.2-imagick
    update-rc.d php7.2-fpm defaults
    a2enconf php7.2-fpm
    systemctl restart apache2
    cp -r /etc/php/7.2/ /root/vst_install_backups/php7.2/
    # rm -f /etc/php/7.2/fpm/pool.d/*
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-72.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-72.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-72.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-72.sh
    if [ $debian_version -eq 9 ]; then
      cp /etc/php/7.0/apache2/php.ini /etc/php/7.2/fpm/php.ini
    fi
    if [ $debian_version -eq 10 ]; then
      cp /etc/php/7.3/fpm/php.ini /etc/php/7.2/fpm/php.ini
    fi
    if [ $debian_version -eq 11 ]; then
      cp /etc/php/7.4/fpm/php.ini /etc/php/7.2/fpm/php.ini
    fi
    press_enter "=== Press enter to continue ==============================================================================="
fi

if [ "$inst_73" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 7.3 ==============================================================================="
    apt-get -y install php7.3-mbstring php7.3-bcmath php7.3-cli php7.3-curl php7.3-fpm php7.3-gd php7.3-intl php7.3-mysql php7.3-soap php7.3-xml php7.3-zip php7.3-memcache php7.3-memcached php7.3-imagick
    update-rc.d php7.3-fpm defaults
    a2enconf php7.3-fpm
    systemctl restart apache2
    cp -r /etc/php/7.3/ /root/vst_install_backups/php7.3/
    # rm -f /etc/php/7.3/fpm/pool.d/*
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-73-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73-public.sh
    if [ $debian_version -eq 9 ]; then
      cp /etc/php/7.0/apache2/php.ini /etc/php/7.3/fpm/php.ini
    fi
    if [ $debian_version -eq 11 ]; then
      cp /etc/php/7.4/fpm/php.ini /etc/php/7.3/fpm/php.ini
    fi
    press_enter "=== Press enter to continue ==============================================================================="
fi

if [ "$inst_74" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 7.4 ==============================================================================="
    apt-get -y install php7.4-mbstring php7.4-bcmath php7.4-cli php7.4-curl php7.4-fpm php7.4-gd php7.4-intl php7.4-mysql php7.4-soap php7.4-xml php7.4-zip php7.4-memcache php7.4-memcached php7.4-imagick
    update-rc.d php7.4-fpm defaults
    a2enconf php7.4-fpm
    apt-get -y remove libapache2-mod-php7.4
    systemctl restart apache2
    cp -r /etc/php/7.4/ /root/vst_install_backups/php7.4/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-74-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74-public.sh
    if [ $debian_version -eq 9 ]; then
        cp /etc/php/7.0/apache2/php.ini /etc/php/7.4/fpm/php.ini
    fi
    if [ $debian_version -eq 10 ]; then
        cp /etc/php/7.3/fpm/php.ini /etc/php/7.4/fpm/php.ini
    fi
    press_enter "=== Press enter to continue ==============================================================================="
fi


if [ "$inst_80" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.0 ==============================================================================="
    apt-get -y install php8.0-mbstring php8.0-bcmath php8.0-cli php8.0-curl php8.0-fpm php8.0-gd php8.0-intl php8.0-mysql php8.0-soap php8.0-xml php8.0-zip php8.0-memcache php8.0-memcached php8.0-imagick
    update-rc.d php8.0-fpm defaults
    a2enconf php8.0-fpm
    a2dismod php8.0
    apt-get -y remove libapache2-mod-php8.0
    systemctl restart apache2
    cp -r /etc/php/8.0/ /root/vst_install_backups/php8.0/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-80-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-80-public.sh
    echo "=== Patching php.ini for php8.0"
    wget -nv https://c.myvestacp.com/tools/patches/php8.0.patch -O /root/php8.0.patch
    patch /etc/php/8.0/fpm/php.ini < /root/php8.0.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.0/fpm/php.ini
    fi
    service php8.0-fpm restart
    press_enter "=== PHP 8.0 installed, press enter to continue ==============================================================================="
fi

if [ "$inst_81" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.1 ==============================================================================="
    apt-get -y install php8.1-mbstring php8.1-bcmath php8.1-cli php8.1-curl php8.1-fpm php8.1-gd php8.1-intl php8.1-mysql php8.1-soap php8.1-xml php8.1-zip php8.1-memcache php8.1-memcached php8.1-imagick
    update-rc.d php8.1-fpm defaults
    a2enconf php8.1-fpm
    a2dismod php8.1
    apt-get -y remove libapache2-mod-php8.1
    systemctl restart apache2
    cp -r /etc/php/8.1/ /root/vst_install_backups/php8.1/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-81-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-81-public.sh
    echo "=== Patching php.ini for php8.1"
    wget -nv https://c.myvestacp.com/tools/patches/php8.1.patch -O /root/php8.1.patch
    patch /etc/php/8.1/fpm/php.ini < /root/php8.1.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.1/fpm/php.ini
    fi
    service php8.1-fpm restart
    press_enter "=== PHP 8.1 installed, press enter to continue ==============================================================================="
fi

if [ "$inst_82" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.2 ==============================================================================="
    apt-get -y install php8.2-mbstring php8.2-bcmath php8.2-cli php8.2-curl php8.2-fpm php8.2-gd php8.2-intl php8.2-mysql php8.2-soap php8.2-xml php8.2-zip php8.2-memcache php8.2-memcached php8.2-imagick
    update-rc.d php8.2-fpm defaults
    a2enconf php8.2-fpm
    a2dismod php8.2
    apt-get -y remove libapache2-mod-php8.2
    systemctl restart apache2
    cp -r /etc/php/8.2/ /root/vst_install_backups/php8.2/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-82-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82-public.sh
    echo "=== Patching php.ini for php8.2"
    wget -nv https://c.myvestacp.com/tools/patches/php8.2.patch -O /root/php8.2.patch
    patch /etc/php/8.2/fpm/php.ini < /root/php8.2.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.2/fpm/php.ini
    fi
    service php8.2-fpm restart
    press_enter "=== PHP 8.2 installed, press enter to continue ==============================================================================="
fi

if [ "$inst_83" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.3 ==============================================================================="
    apt-get -y install php8.3-mbstring php8.3-bcmath php8.3-cli php8.3-curl php8.3-fpm php8.3-gd php8.3-intl php8.3-mysql php8.3-soap php8.3-xml php8.3-zip php8.3-memcache php8.3-memcached php8.3-imagick
    update-rc.d php8.3-fpm defaults
    a2enconf php8.3-fpm
    a2dismod php8.3
    apt-get -y remove libapache2-mod-php8.3
    systemctl restart apache2
    cp -r /etc/php/8.3/ /root/vst_install_backups/php8.3/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-83-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-83-public.sh
    echo "=== Patching php.ini for php8.3"
    wget -nv https://c.myvestacp.com/tools/patches/php8.2.patch -O /root/php8.3.patch
    patch /etc/php/8.3/fpm/php.ini < /root/php8.3.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.3/fpm/php.ini
    fi
    service php8.3-fpm restart
    press_enter "=== PHP 8.3 installed, press enter to continue ==============================================================================="
fi

if [ "$inst_84" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.4 ==============================================================================="
    apt-get -y install php8.4-mbstring php8.4-bcmath php8.4-cli php8.4-curl php8.4-fpm php8.4-gd php8.4-intl php8.4-mysql php8.4-soap php8.4-xml php8.4-zip php8.4-memcache php8.4-memcached php8.4-imagick
    update-rc.d php8.4-fpm defaults
    a2enconf php8.4-fpm
    a2dismod php8.4
    apt-get -y remove libapache2-mod-php8.4
    systemctl restart apache2
    cp -r /etc/php/8.4/ /root/vst_install_backups/php8.4/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-84-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-84-public.sh
    echo "=== Patching php.ini for php8.4"
    wget -nv https://c.myvestacp.com/tools/patches/php8.2.patch -O /root/php8.4.patch
    patch /etc/php/8.4/fpm/php.ini < /root/php8.4.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.4/fpm/php.ini
    fi
    service php8.4-fpm restart
    press_enter "=== PHP 8.4 installed, press enter to continue ==============================================================================="
fi

if [ "$inst_85" -eq 1 ]; then
    press_enter "=== Press enter to install PHP 8.5 ==============================================================================="
    apt-get -y install php8.5-mbstring php8.5-bcmath php8.5-cli php8.5-curl php8.5-fpm php8.5-gd php8.5-intl php8.5-mysql php8.5-soap php8.5-xml php8.5-zip php8.5-memcache php8.5-memcached php8.5-imagick
    update-rc.d php8.5-fpm defaults
    a2enconf php8.5-fpm
    a2dismod php8.5
    apt-get -y remove libapache2-mod-php8.5
    systemctl restart apache2
    cp -r /etc/php/8.5/ /root/vst_install_backups/php8.5/
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85.sh
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85-public.stpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85-public.stpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85-public.tpl -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85-public.tpl
    wget -nv https://c.myvestacp.com/tools/apache-fpm-tpl/PHP-FPM-85-public.sh -O /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85-public.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85.sh
    chmod a+x /usr/local/vesta/data/templates/web/apache2/PHP-FPM-85-public.sh
    echo "=== Patching php.ini for php8.5"
    wget -nv https://c.myvestacp.com/tools/patches/php8.5.patch -O /root/php8.5.patch
    patch /etc/php/8.5/fpm/php.ini < /root/php8.5.patch
    if [ $memory -gt 9999999 ]; then
        sed -i "s|opcache.memory_consumption=512|opcache.memory_consumption=2048|g" /etc/php/8.5/fpm/php.ini
    fi
    service php8.5-fpm restart
    press_enter "=== PHP 8.5 installed, press enter to continue ==============================================================================="
fi

# apt update > /dev/null 2>&1
# apt upgrade -y > /dev/null 2>&1

if [ $debian_version -ge 10 ]; then
    a2dismod ruid2 > /dev/null 2>&1
    a2dismod suexec > /dev/null 2>&1
    a2dismod php5.6 > /dev/null 2>&1
    a2dismod php7.0 > /dev/null 2>&1
    a2dismod php7.1 > /dev/null 2>&1
    a2dismod php7.2 > /dev/null 2>&1
    a2dismod php7.3 > /dev/null 2>&1
    a2dismod php7.4 > /dev/null 2>&1
    a2dismod php8.0 > /dev/null 2>&1
    a2dismod php8.1 > /dev/null 2>&1
    a2dismod php8.2 > /dev/null 2>&1
    a2dismod php8.3 > /dev/null 2>&1
    a2dismod php8.4 > /dev/null 2>&1
    a2dismod php8.5 > /dev/null 2>&1
    a2dismod mpm_prefork > /dev/null 2>&1
    a2enmod mpm_event > /dev/null 2>&1
    apt-get -y remove libapache2-mod-php* > /dev/null 2>&1
    service apache2 restart
fi

if [ -f "/usr/share/phpgate/phpgate.php" ]; then
    echo "=== upgrading phpgate"
    /usr/local/vesta/bin/v-commander 'm' 'inst pgw' 'q'
    echo "=== upgrading phpgate done."
    echo ""
fi

if [ -f "/usr/local/bin/tailf_apache_error.php" ]; then
    echo "=== upgrading tailf_apache_error.php"
    wget -nv http://dl.myvestacp.com/vesta/tailf.php -O /usr/local/bin/tailf.php
    wget -nv http://dl.myvestacp.com/vesta/tailf_apache_error.php -O /usr/local/bin/tailf_apache_error.php
    wget -nv http://dl.myvestacp.com/vesta/see-apache-processlist-once.sh -O /usr/local/bin/see-apache-processlist-once.sh
    wget -nv http://dl.myvestacp.com/vesta/see-mysql-processlist-once.sh -O /usr/local/bin/see-mysql-processlist-once.sh
    chmod u+x /usr/local/bin/see-apache-processlist-once.sh
    chmod u+x /usr/local/bin/see-mysql-processlist-once.sh
    
    # ps aux | grep 'tailf_apache_error' | grep -v "grep tailf_apache_error"
    # echo $(ps aux | grep 'tailf_apache_error' | grep -v "grep tailf_apache_error" | awk '{print $2}')
    kill $(ps aux | grep 'tailf_apache_error' | grep -v "grep tailf_apache_error" | awk '{print $2}')
    sleep 1
    # ps -Af | grep 'tailf_apache_error' | grep -v "grep tailf_apache_error"
    # sleep 1
    nohup php /usr/local/bin/tailf_apache_error.php > /var/log/tailf_apache_error.log &
    echo "=== upgrading tailf_apache_error.php done."
    sleep 3
    echo ""
fi

# Fixing php.ini files to have the correct disable_functions line
/usr/local/vesta/bin/v-fix-php-ini-disable-functions

echo "Everything done."
echo ""

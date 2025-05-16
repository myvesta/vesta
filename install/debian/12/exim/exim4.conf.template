#!/bin/bash

# myVesta Debian installer v 0.9

#----------------------------------------------------------#
#                  Variables & Functions                   #
#----------------------------------------------------------#
export PATH=$PATH:/sbin
export DEBIAN_FRONTEND=noninteractive

# Define repository and installation paths
RHOST='apt.myvestacp.com'
CHOST='c.myvestacp.com'
VERSION='debian'
VESTA='/usr/local/vesta'
memory=$(grep 'MemTotal' /proc/meminfo |tr ' ' '\n' |grep [0-9])
arch=$(uname -i)
os='debian'
release=$(cat /etc/debian_version | tr "." "\n" | head -n1)
codename="$(cat /etc/os-release |grep VERSION= |cut -f 2 -d \(|cut -f 1 -d \))"
vestacp="$VESTA/install/$VERSION/$release"
ARCH="amd64"

# Define software packages based on Debian release
if [ "$release" -eq 12 ]; then
    software="nginx apache2 apache2-utils
        libapache2-mod-fcgid php-fpm php
        php-common php-cgi php-mysql php-curl php-fpm php-pgsql awstats
        vsftpd proftpd-basic bind9 exim4 exim4-daemon-heavy
        clamav-daemon spamassassin dovecot-imapd dovecot-pop3d roundcube-core
        roundcube-mysql roundcube-plugins mariadb-server mariadb-common
        mariadb-client postgresql postgresql-contrib phpmyadmin mc
        flex whois git idn zip sudo bc ftp lsof ntpdate rrdtool quota
        e2fslibs bsdutils e2fsprogs curl imagemagick fail2ban dnsutils
        bsdmainutils cron vesta vesta-nginx vesta-php expect libmail-dkim-perl
        unrar-free vim-common net-tools unzip iptables xxd spamd rsyslog"
elif [ "$release" -eq 11 ]; then
    software="nginx apache2 apache2-utils
        libapache2-mod-fcgid php-fpm php
        php-common php-cgi php-mysql php-curl php-fpm php-pgsql awstats
        vsftpd proftpd-basic bind9 exim4 exim4-daemon-heavy
        clamav-daemon spamassassin dovecot-imapd dovecot-pop3d roundcube-core
        roundcube-mysql roundcube-plugins mariadb-server mariadb-common
        mariadb-client postgresql postgresql-contrib phppgadmin phpmyadmin mc
        flex whois git idn zip sudo bc ftp lsof ntpdate rrdtool quota
        e2fslibs bsdutils e2fsprogs curl imagemagick fail2ban dnsutils
        bsdmainutils cron vesta vesta-nginx vesta-php expect libmail-dkim-perl
        unrar-free vim-common net-tools unzip iptables"
elif [ "$release" -eq 10 ]; then
    software="nginx apache2 apache2-utils
        libapache2-mod-fcgid php-fpm php
        php-common php-cgi php-mysql php-curl php-fpm php-pgsql awstats
        webalizer vsftpd proftpd-basic bind9 exim4 exim4-daemon-heavy
        clamav-daemon spamassassin dovecot-imapd dovecot-pop3d roundcube-core
        roundcube-mysql roundcube-plugins mariadb-server mariadb-common
        mariadb-client postgresql postgresql-contrib phppgadmin mc
        flex whois git idn zip sudo bc ftp lsof ntpdate rrdtool quota
        e2fslibs bsdutils e2fsprogs curl imagemagick fail2ban dnsutils
        bsdmainutils cron vesta vesta-nginx vesta-php expect libmail-dkim-perl
        unrar-free vim-common net-tools unzip"
elif [ "$release" -eq 9 ]; then
    echo "==================================================="
    echo "Important message:"
    echo "myVesta is much more faster with Debian 10 ."
    echo "Are you sure you want to continue with Debian 9 ?"
    read -p "==================================================="
    software="nginx apache2 apache2-utils apache2-suexec-custom
        libapache2-mod-ruid2 libapache2-mod-fcgid libapache2-mod-php php
        php-common php-cgi php-mysql php-curl php-fpm php-pgsql awstats
        webalizer vsftpd proftpd-basic bind9 exim4 exim4-daemon-heavy
        clamav-daemon spamassassin dovecot-imapd dovecot-pop3d roundcube-core
        roundcube-mysql roundcube-plugins mysql-server mysql-common
        mysql-client postgresql postgresql-contrib phppgadmin phpmyadmin mc
        flex whois rssh git idn zip sudo bc ftp lsof ntpdate rrdtool quota
        e2fslibs bsdutils e2fsprogs curl imagemagick fail2ban dnsutils
        bsdmainutils cron vesta vesta-nginx vesta-php expect libmail-dkim-perl
        unrar-free vim-common net-tools unzip"
elif [ "$release" -eq 8 ]; then
    echo "==================================================="
    echo "Important message:"
    echo "myVesta is much more faster with Debian 10 ."
    echo "Are you sure you want to continue with Debian 8 ?"
    read -p "==================================================="
    software="nginx apache2 apache2-utils apache2.2-common
        apache2-suexec-custom libapache2-mod-ruid2
        libapache2-mod-fcgid libapache2-mod-php5 php5 php5-common php5-cgi
        php5-mysql php5-curl php5-fpm php5-pgsql awstats webalizer vsftpd
        proftpd-basic bind9 exim4 exim4-daemon-heavy clamav-daemon
        spamassassin dovecot-imapd dovecot-pop3d roundcube-core
        roundcube-mysql roundcube-plugins mysql-server mysql-common
        mysql-client postgresql postgresql-contrib phppgadmin phpMyAdmin mc
        flex whois rssh git idn zip sudo bc ftp lsof ntpdate rrdtool quota
        e2fslibs bsdutils e2fsprogs curl imagemagick fail2ban dnsutils
        bsdmainutils cron vesta vesta-nginx vesta-php expect libmail-dkim-perl
        unrar-free vim-common net-tools unzip"
fi

# Function to display usage information
help() {
    echo "Usage: $0 [OPTIONS]
  -a, --apache            Install Apache        [yes|no]  default: yes
  -n, --nginx             Install Nginx         [yes|no]  default: yes
  -w, --phpfpm            Install PHP-FPM       [yes|no]  default: no
  -v, --vsftpd            Install Vsftpd        [yes|no]  default: no
  -j, --proftpd           Install ProFTPD       [yes|no]  default: yes
  -k, --named             Install Bind          [yes|no]  default: yes
  -m, --mysql             Install MariaDB       [yes|no]  default: yes
  -d, --mysql8            Install MySQL 8       [yes|no]  default: no
  -g, --postgresql        Install PostgreSQL    [yes|no]  default: no
  -x, --exim              Install Exim          [yes|no]  default: yes
  -z, --dovecot           Install Dovecot       [yes|no]  default: yes
  -c, --clamav            Install ClamAV        [yes|no]  default: yes
  -t, --spamassassin      Install SpamAssassin  [yes|no]  default: yes
  -i, --iptables          Install Iptables      [yes|no]  default: yes
  -b, --fail2ban          Install Fail2ban      [yes|no]  default: yes
  -o, --softaculous       Install Softaculous   [yes|no]  default: no
  -q, --quota             Filesystem Quota      [yes|no]  default: no
  -l, --lang              Default language                default: en
  -y, --interactive       Interactive install   [yes|no]  default: yes
  -s, --hostname          Set hostname
  -e, --email             Set admin email
  -p, --password          Set admin password
  -u, --secret_url        Set secret url for hosting panel
  -1, --port              Set Vesta port
  -f, --force             Force installation
  -h, --help              Print this help

  Example: bash $0 -e demo@myvestacp.com -p p4ssw0rd --apache no --phpfpm yes"
    exit 1
}

# Function to generate a random password
gen_pass() {
    MATRIX='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
    if [ -z "$1" ]; then
        LENGTH=32
    else
        LENGTH=$1
    fi
    while [ ${n:=1} -le $LENGTH ]; do
        PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
        let n+=1
    done
    echo "$PASS"
}

# Function to check the result of a command and exit on failure
check_result() {
    if [ $1 -ne 0 ]; then
        echo "Error: $2"
        exit $1
    fi
}

# Function to set a default value for a variable
set_default_value() {
    eval variable=\$$1
    if [ -z "$variable" ]; then
        eval $1=$2
    fi
    if [ "$variable" != 'yes' ] && [ "$variable" != 'no' ]; then
        eval $1=$2
    fi
}

# Function to set a default language value
set_default_lang() {
    if [ -z "$lang" ]; then
        eval lang=$1
    fi
    lang_list="
        ar cz el fa hu ja no pt se ua
        bs da en fi id ka pl ro tr vi
        cn de es fr it nl pt-BR ru tw
        bg ko sr th ur"
    if !(echo $lang_list |grep -w $lang 1>&2>/dev/null); then
        eval lang=$1
    fi
}

# Function to ensure a service is enabled on startup
ensure_startup() {
    echo "- Making sure startup is enabled for: $1"
    currentservice=$1
    unit_files="$(systemctl list-unit-files |grep $currentservice)"
    if [[ "$unit_files" =~ "disabled" ]]; then
        systemctl enable $currentservice
    fi
}

# Function to ensure a service is started
ensure_start() {
    echo "- Making sure $1 is started"
    currentservice=$1
    systemctl status $currentservice.service > /dev/null 2>&1
    r=$?
    if [ $r -ne 0 ]; then
        systemctl start $currentservice
        check_result $? "$currentservice start failed"
    fi
}

#----------------------------------------------------------#
#                    Verifications                         #
#----------------------------------------------------------#

# Create a temporary file for storing intermediate data
tmpfile=$(mktemp -p /tmp)

# Translate arguments to long options
for arg; do
    delim=""
    case "$arg" in
        --apache)               args="${args}-a " ;;
        --nginx)                args="${args}-n " ;;
        --phpfpm)               args="${args}-w " ;;
        --vsftpd)               args="${args}-v " ;;
        --proftpd)              args="${args}-j " ;;
        --named)                args="${args}-k " ;;
        --mysql)                args="${args}-m " ;;
        --mysql8)               args="${args}-d " ;;
        --postgresql)           args="${args}-g " ;;
        --mongodb)              args="${args}-d " ;;
        --exim)                 args="${args}-x " ;;
        --dovecot)              args="${args}-z " ;;
        --clamav)               args="${args}-c " ;;
        --spamassassin)         args="${args}-t " ;;
        --iptables)             args="${args}-i " ;;
        --fail2ban)             args="${args}-b " ;;
        --remi)                 args="${args}-r " ;;
        --softaculous)          args="${args}-o " ;;
        --quota)                args="${args}-q " ;;
        --lang)                 args="${args}-l " ;;
        --interactive)          args="${args}-y " ;;
        --hostname)             args="${args}-s " ;;
        --email)                args="${args}-e " ;;
        --secret_url)           args="${args}-u " ;;
        --port)                 args="${args}-1 " ;;
        --password)             args="${args}-p " ;;
        --force)                args="${args}-f " ;;
        --help)                 args="${args}-h " ;;
        *)                      [[ "${arg:0:1}" == "-" ]] || delim="\""
                                args="${args}${delim}${arg}${delim} ";;
    esac
done
eval set -- "$args"

# Parse command-line arguments
while getopts "a:n:w:v:j:k:m:g:d:x:z:c:t:i:b:r:o:q:l:y:s:e:p:u:1:fh" Option; do
    case $Option in
        a) apache=$OPTARG ;;            # Apache
        n) nginx=$OPTARG ;;             # Nginx
        w) phpfpm=$OPTARG ;;            # PHP-FPM
        v) vsftpd=$OPTARG ;;            # Vsftpd
        j) proftpd=$OPTARG ;;           # Proftpd
        k) named=$OPTARG ;;             # Named
        m) mysql=$OPTARG ;;             # MariaDB
        d) mysql8=$OPTARG ;;            # MySQL8
        g) postgresql=$OPTARG ;;        # PostgreSQL
        d) mongodb=$OPTARG ;;           # MongoDB (unsupported)
        x) exim=$OPTARG ;;              # Exim
        z) dovecot=$OPTARG ;;           # Dovecot
        c) clamd=$OPTARG ;;             # ClamAV
        t) spamd=$OPTARG ;;             # SpamAssassin
        i) iptables=$OPTARG ;;          # Iptables
        b) fail2ban=$OPTARG ;;          # Fail2ban
        r) remi=$OPTARG ;;              # Remi repo
        o) softaculous=$OPTARG ;;       # Softaculous plugin
        q) quota=$OPTARG ;;             # FS Quota
        l) lang=$OPTARG ;;              # Language
        y) interactive=$OPTARG ;;       # Interactive install
        s) servername=$OPTARG ;;        # Hostname
        e) email=$OPTARG ;;             # Admin email
        u) secret_url=$OPTARG ;;        # Secret URL for hosting panel
        1) port=$OPTARG ;;              # Vesta port
        p) vpass=$OPTARG ;;             # Admin password
        f) force='yes' ;;               # Force install
        h) help ;;                      # Help
        *) help ;;                      # Print help (default)
    esac
done

# Set default values for software stack
set_default_value 'nginx' 'yes'
set_default_value 'apache' 'yes'
set_default_value 'phpfpm' 'no'
set_default_value 'vsftpd' 'no'
set_default_value 'proftpd' 'yes'
set_default_value 'named' 'yes'
set_default_value 'mysql' 'yes'
set_default_value 'mysql8' 'no'
set_default_value 'postgresql' 'no'
set_default_value 'mongodb' 'no'
set_default_value 'exim' 'yes'
set_default_value 'dovecot' 'yes'
if [ $memory -lt 2500000 ]; then
    set_default_value 'clamd' 'no'
    set_default_value 'spamd' 'no'
else
    set_default_value 'clamd' 'yes'
    set_default_value 'spamd' 'yes'
fi
set_default_value 'iptables' 'yes'
set_default_value 'fail2ban' 'yes'
set_default_value 'softaculous' 'no'
set_default_value 'quota' 'no'
set_default_value 'interactive' 'yes'
set_default_lang 'en'

# Resolve software conflicts
if [ "$proftpd" = 'yes' ]; then
    vsftpd='no'
fi
if [ "$exim" = 'no' ]; then
    clamd='no'
    spamd='no'
    dovecot='no'
fi
if [ "$iptables" = 'no' ]; then
    fail2ban='no'
fi
if [ "$mysql8" = 'yes' ]; then
    mysql='no'
fi

# Check for root permissions
if [ "x$(id -u)" != 'x0' ]; then
    check_error 1 "Script can be run executed only by root"
fi

# Check for existing admin user
if [ ! -z "$(grep ^admin: /etc/passwd)" ] && [ -z "$force" ]; then
    echo 'Please remove admin user account before proceeding.'
    echo 'If you want to do it automatically run installer with -f option:'
    echo -e "Example: bash $0 --force\n"
    check_result 1 "User admin exists"
fi

# Update apt repositories
echo "Updating apt, please wait..."
apt-get update > /dev/null 2>&1

# Install wget if not present
if [ ! -e '/usr/bin/wget' ]; then
    apt-get -y install wget > /dev/null 2>&1
    check_result $? "Can't install wget"
fi

# Install gnupg2 if not present
if [ $(dpkg-query -W -f='${Status}' gnupg2 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    apt-get -y install gnupg2 > /dev/null 2>&1
fi

# Check if apparmor is installed
if [ $(dpkg-query -W -f='${Status}' apparmor 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    apparmor='no'
else
    apparmor='yes'
fi

# Check repository availability
wget -q "apt.myvestacp.com/deb_signing.key" -O /dev/null
check_result $? "No access to Vesta repository"

# Check for installed conflicting packages
tmpfile=$(mktemp -p /tmp)
dpkg --get-selections > $tmpfile
for pkg in exim4 mysql-server apache2 nginx vesta; do
    if [ ! -z "$(grep $pkg $tmpfile)" ]; then
        conflicts="$pkg $conflicts"
    fi
done
rm -f $tmpfile

if [ ! -z "$conflicts" ] && [[ "$conflicts" = *"exim4"* ]]; then
    echo "=== Removing pre-installed exim4"
    apt remove --purge -y exim4 exim4-base exim4-config
    rm -rf /etc/exim4
    conflicts=$(echo "$conflicts" | sed -e "s/exim4//")
    conflicts=$(echo "$conflicts" | sed -e "s/ //")
fi

if [ ! -z "$conflicts" ] && [ -z "$force" ]; then
    echo '!!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!!'
    echo
    echo 'Following packages are already installed:'
    echo "$conflicts"
    echo
    echo 'It is highly recommended to remove them before proceeding.'
    echo 'If you want to force installation run this script with -f option:'
    echo "Example: bash $0 --force"
    echo
    echo '!!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!! !!!'
    echo
    check_result 1 "Control Panel should be installed on clean server."
fi

#----------------------------------------------------------#
#                       Brief Info                         #
#----------------------------------------------------------#

# Display installation banner
clear
echo
echo "                __     __        _        "
echo "  _ __ ___  _   \ \   / /__  ___| |_ __ _ "
echo " | '_ \` _ \| | | \ \ / / _ \/ __| __/ _\` |"
echo " | | | | | | |_| |\ V /  __/\__ \ || (_| |"
echo " |_| |_| |_|\__, | \_/ \___||___/\__\__,_|"
echo "            |___/                         "
echo
echo '                                myVesta Control Panel'
echo -e "\n\n"

echo 'Following software will be installed on your system:'

# Display web stack information
if [ "$nginx" = 'yes' ]; then
    echo '   - nginx Web server'
fi
if [ "$apache" = 'yes' ] && [ "$nginx" = 'no' ] ; then
    echo '   - Apache web server'
fi
if [ "$apache" = 'yes' ] && [ "$nginx"  = 'yes' ] ; then
    echo '   - Apache web server (in very fast mpm_event mode)'
    echo '   - PHP-FPM service for PHP processing'
fi
if [ "$phpfpm"  = 'yes' ]; then
    echo '   - PHP-FPM service for PHP processing'
fi

# Display DNS stack information
if [ "$named" = 'yes' ]; then
    echo '   - Bind9 DNS service'
fi

# Display mail stack information
if [ "$exim" = 'yes' ]; then
    echo -n '   - Exim4 mail server'
    if [ "$clamd" = 'yes'  ] ||  [ "$spamd" = 'yes' ] ; then
        if [ "$clamd" = 'yes' ]; then
            echo -n ' + ClamAV antivirus'
        fi
        if [ "$spamd" = 'yes' ]; then
            echo -n ' + SpamAssassin antispam service'
        fi
    fi
    echo
    if [ "$dovecot" = 'yes' ]; then
        echo '   - Dovecot POP3/IMAP service'
    fi
fi

# Display database stack information
if [ "$mysql" = 'yes' ]; then
    echo '   - MariaDB Database server'
fi
if [ "$mysql8" = 'yes' ]; then
    echo '   - MySQL 8 Database server'
fi
if [ "$postgresql" = 'yes' ]; then
    echo '   - PostgreSQL Database server'
fi

# Display FTP stack information
if [ "$vsftpd" = 'yes' ]; then
    echo '   - Vsftpd FTP service'
fi
if [ "$proftpd" = 'yes' ]; then
    echo '   - ProFTPD FTP service'
fi

# Display Softaculous information
if [ "$softaculous" = 'yes' ]; then
    echo '   - Softaculous Plugin'
fi

# Display firewall stack information
if [ "$iptables" = 'yes' ]; then
    echo -n '   - iptables firewall'
fi
if [ "$iptables" = 'yes' ] && [ "$fail2ban" = 'yes' ]; then
    echo -n ' + Fail2Ban service'
fi
echo -e "\n\n"

# Ask for confirmation to proceed in interactive mode
if [ "$interactive" = 'yes' ]; then
    read -p 'Would you like to continue [y/n]: ' answer
    if [ "$answer" != 'y' ] && [ "$answer" != 'Y'  ]; then
        echo 'Goodbye'
        exit 1
    fi

    # Prompt for admin email if not provided
    if [ -z "$email" ]; then
        read -p 'Please enter admin email address: ' email
    fi

    # Prompt for secret URL if not provided
    if [ -z "$secret_url" ]; then
        echo 'Please enter secret URL address for hosting panel (or press enter for none).'
        echo 'Secret URL must be without special characters, just letters and numbers. Example: mysecret8205'
        read -p 'Enter secret URL address: ' secret_url
    fi

    # Prompt for Vesta port if not provided
    if [ -z "$port" ]; then
        read -p 'Please enter Vesta port number (press enter for 8083): ' port
    fi

    # Prompt for FQDN hostname if not provided
    if [ -z "$servername" ]; then
        read -p "Please enter FQDN hostname [$(hostname)]: " servername
    fi
fi

# Generate admin password if not provided
if [ -z "$vpass" ]; then
    vpass=$(gen_pass)
fi

# Set hostname if not provided
if [ -z "$servername" ]; then
    servername=$(hostname -f)
fi

# Validate and set FQDN hostname
mask1='(([[:alnum:]](-?[[:alnum:]])*)\.)'
mask2='*[[:alnum:]](-?[[:alnum:]])+\.[[:alnum:]]{2,}'
if ! [[ "$servername" =~ ^${mask1}${mask2}$ ]]; then
    if [ ! -z "$servername" ]; then
        servername="$servername.example.com"
    else
        servername="example.com"
    fi
    echo "127.0.0.1 $servername" >> /etc/hosts
fi
echo "$servername" > /etc/hostname
hostname $servername

# Derive Exim primary_hostname as mail.<base domain>
# Extract the base domain (last two parts, e.g., server.example.com -> example.com)
base_domain=$(echo $servername | rev | cut -d'.' -f1-2 | rev)
# Handle cases with more complex TLDs (e.g., server.example.co.uk -> example.co.uk)
if [[ $servername =~ \.[a-z]+\.[a-z]+\.[a-z]+$ ]]; then
    # For cases like server.example.co.uk, take the last three parts
    base_domain=$(echo $servername | rev | cut -d'.' -f1-3 | rev)
fi
# Set primary_hostname to mail.<base domain>
exim_hostname="mail.$base_domain"
# Fallback to mail.example.com if base_domain is invalid
if [ -z "$base_domain" ] || ! [[ "$base_domain" =~ ^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$ ]]; then
    exim_hostname="mail.example.com"
fi

# Set email if not provided
if [ -z "$email" ]; then
    email="admin@$servername"
fi

# Set port if not provided
if [ -z "$port" ]; then
    port="8083"
fi

# Define backup directory
vst_backups="/root/vst_install_backups/$(date +%s)"
echo "Installation backup directory: $vst_backups"

# Display start message and wait for 5 seconds
echo -e "\n\n\n\nInstallation will take about 15 minutes ...\n"
sleep 5

#----------------------------------------------------------#
#                      Checking Swap                       #
#----------------------------------------------------------#

# Enable swap on small instances if not already enabled
if [ -z "$(swapon -s)" ] && [ $memory -lt 1000000 ]; then
    echo "== Checking swap on small instances"
    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
fi

#----------------------------------------------------------#
#                   Install Repository                     #
#----------------------------------------------------------#

echo "=== Updating system (apt-get -y upgrade)"
apt-get -y upgrade
check_result $? 'apt-get upgrade failed'

echo "=== Installing nginx repo"
apt="/etc/apt/sources.list.d"
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/nginx-keyring.gpg] https://nginx.org/packages/mainline/$VERSION/ $codename nginx" > $apt/nginx.list
curl -s https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-keyring.gpg > /dev/null 2>&1

echo "=== Installing myVesta repo"
echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/myvesta-keyring.gpg] https://$RHOST/$codename/ $codename vesta" > $apt/vesta.list
curl -s $CHOST/deb_signing.key | gpg --dearmor | tee /usr/share/keyrings/myvesta-keyring.gpg > /dev/null 2>&1

# Install jessie backports for Debian 8
if [ "$release" -eq 8 ]; then
    if [ ! -e /etc/apt/apt.conf ]; then
        echo 'Acquire::Check-Valid-Until "false";' >> /etc/apt/apt.conf
    fi
    if [ ! -e /etc/apt/sources.list.d/backports.list ]; then
        echo "deb http://archive.debian.org/debian jessie-backports main" >\
            /etc/apt/sources.list.d/backports.list
    fi
fi

#----------------------------------------------------------#
#                         Backup                           #
#----------------------------------------------------------#

mkdir /backup

echo "=== Creating backup directory tree"
mkdir -p $vst_backups
cd $vst_backups
mkdir nginx apache2 php php5 php5-fpm vsftpd proftpd bind exim4 dovecot clamd
mkdir spamassassin mysql postgresql mongodb vesta

echo "=== Backing up old configs"
# Backup Nginx configuration
service nginx stop > /dev/null 2>&1
cp -r /etc/nginx/* $vst_backups/nginx >/dev/null 2>&1

# Backup Apache configuration
service apache2 stop > /dev/null 2>&1
cp -r /etc/apache2/* $vst_backups/apache2 > /dev/null 2>&1
rm -f /etc/apache2/conf.d/* > /dev/null 2>&1

# Backup PHP configuration
cp /etc/php.ini $vst_backups/php > /dev/null 2>&1
cp -r /etc/php.d  $vst_backups/php > /dev/null 2>&1

# Backup PHP5-FPM configuration
service php5-fpm stop >/dev/null 2>&1
cp /etc/php5/* $vst_backups/php5 > /dev/null 2>&1
rm -f /etc/php5/fpm/pool.d/* >/dev/null 2>&1

# Backup Bind configuration
service bind9 stop > /dev/null 2>&1
cp -r /etc/bind/* $vst_backups/bind > /dev/null 2>&1

# Backup Vsftpd configuration
service vsftpd stop > /dev/null 2>&1
cp /etc/vsftpd.conf $vst_backups/vsftpd > /dev/null 2>&1

# Backup ProFTPD configuration
service proftpd stop > /dev/null 2>&1
cp /etc/proftpd.conf $vst_backups/proftpd >/dev/null 2>&1

# Backup Exim configuration
service exim4 stop > /dev/null 2>&1
cp -r /etc/exim4/* $vst_backups/exim4 > /dev/null 2>&1

# Backup ClamAV configuration
service clamav-daemon stop > /dev/null 2>&1
cp -r /etc/clamav/* $vst_backups/clamav > /dev/null 2>&1

# Backup SpamAssassin configuration
service spamassassin stop > /dev/null 2>&1
cp -r /etc/spamassassin/* $vst_backups/spamassassin > /dev/null 2>&1

# Backup Dovecot configuration
service dovecot stop > /dev/null 2>&1
cp /etc/dovecot.conf $vst_backups/dovecot > /dev/null 2>&1
cp -r /etc/dovecot/* $vst_backups/dovecot > /dev/null 2>&1

# Backup MySQL/MariaDB configuration and data
service mysql stop > /dev/null 2>&1
killall -9 mysqld > /dev/null 2>&1
mv /var/lib/mysql $vst_backups/mysql/mysql_datadir > /dev/null 2>&1
cp -r /etc/mysql/* $vst_backups/mysql > /dev/null 2>&1
mv -f /root/.my.cnf $vst_backups/mysql > /dev/null 2>&1

# Backup Vesta
service vesta stop > /dev/null 2>&1
cp -r $VESTA/* $vst_backups/vesta > /dev/null 2>&1
apt-get -y remove vesta vesta-nginx vesta-php > /dev/null 2>&1
apt-get -y purge vesta vesta-nginx vesta-php > /dev/null 2>&1
rm -rf $VESTA > /dev/null 2>&1

#----------------------------------------------------------#
#                     Package Excludes                     #
#----------------------------------------------------------#

# Exclude packages based on user choices
if [ "$nginx" = 'no'  ]; then
    software=$(echo "$software" | sed -e "s/^nginx//")
fi
if [ "$apache" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/apache2 //")
    software=$(echo "$software" | sed -e "s/apache2-utils//")
    software=$(echo "$software" | sed -e "s/apache2-suexec-custom//")
    software=$(echo "$software" | sed -e "s/apache2.2-common//")
    software=$(echo "$software" | sed -e "s/libapache2-mod-ruid2//")
    software=$(echo "$software" | sed -e "s/libapache2-mod-fcgid//")
    software=$(echo "$software" | sed -e "s/libapache2-mod-php5//")
    software=$(echo "$software" | sed -e "s/libapache2-mod-php//")
fi
if [ "$vsftpd" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/vsftpd//")
fi
if [ "$proftpd" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/proftpd-basic//")
    software=$(echo "$software" | sed -e "s/proftpd-mod-vroot//")
fi
if [ "$named" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/bind9//")
fi
if [ "$exim" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/exim4 //")
    software=$(echo "$software" | sed -e "s/exim4-daemon-heavy//")
    software=$(echo "$software" | sed -e "s/dovecot-imapd//")
    software=$(echo "$software" | sed -e "s/dovecot-pop3d//")
    software=$(echo "$software" | sed -e "s/clamav-daemon//")
    software=$(echo "$software" | sed -e "s/spamassassin//")
fi
if [ "$clamd" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/clamav-daemon//")
fi
if [ "$spamd" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/spamassassin//")
    software=$(echo "$software" | sed -e "s/libmail-dkim-perl//")
fi
if [ "$dovecot" = 'no' ]; then
    software=$(echo "$software" | sed -e "s/dovecot-imapd//")
    software=$(echo "$software" | sed -e "s/dovecot-pop3d//")
fi
if [ "$mysql" = 'no' ]; then
    software=$(echo "$software" | sed -e 's/mysql-server//')
    software=$(echo "$software" | sed -e 's/mysql-client//')
    software=$(echo "$software" | sed -e 's/mysql-common//')
    software=$(echo "$software" | sed -e 's/mariadb-server//')
    software=$(echo "$software" | sed -e 's/mariadb-client//')
    software=$(echo "$software" | sed -e 's/mariadb-common//')
    software=$(echo "$software" | sed -e 's/php5-mysql//')
    software=$(echo "$software" | sed -e 's/php-mysql//')
    software=$(echo "$software" | sed -e 's/phpMyAdmin//')
    software=$(echo "$software" | sed -e 's/phpmyadmin//')
    software=$(echo "$software" | sed -e 's/roundcube-mysql//')
fi
if [ "$mysql8" = 'yes' ]; then
    echo "=== Preparing MySQL 8 apt repo"
    if [ "$release" -lt 12 ]; then
        software=$(echo "$software" | sed -e 's/exim4-daemon-heavy//')
        software=$(echo "$software" | sed -e 's/exim4//')
        echo "### THIS FILE IS AUTOMATICALLY CONFIGURED ###" > /etc/apt/sources.list.d/mysql.list
        echo "# You may comment out entries below, but any other modifications may be lost." >> /etc/apt/sources.list.d/mysql.list
        echo "# Use command 'dpkg-reconfigure mysql-apt-config' as root for modifications." >> /etc/apt/sources.list.d/mysql.list
        echo "deb http://repo.mysql.com/apt/debian/ $codename mysql-apt-config" >> /etc/apt/sources.list.d/mysql.list
        echo "deb http://repo.mysql.com/apt/debian/ $codename mysql-8.0" >> /etc/apt/sources.list.d/mysql.list
        echo "deb http://repo.mysql.com/apt/debian/ $codename mysql-tools" >> /etc/apt/sources.list.d/mysql.list
        echo "#deb http://repo.mysql.com/apt/debian/ $codename mysql-tools-preview" >> /etc/apt/sources.list.d/mysql.list
        echo "deb-src http://repo.mysql.com/apt/debian/ $codename mysql-8.0" >> /etc/apt/sources.list.d/mysql.list

        key="467B942D3A79BD29"
        readonly key
        GNUPGHOME="$(mktemp -d)"
        export GNUPGHOME
        for keyserver in $(shuf -e ha.pool.sks-keyservers.net hkp://p80.pool.sks-keyservers.net:80 keyserver.ubuntu.com hkp://keyserver.ubuntu.com:80)
        do
            gpg --keyserver "${keyserver}" --recv-keys "${key}" 2>&1 && break
        done
        gpg --export "${key}" > /etc/apt/trusted.gpg.d/mysql.gpg
        gpgconf --kill all
        rm -rf "${GNUPGHOME}"
        unset GNUPGHOME
    else
        wget https://dev.mysql.com/get/mysql-apt-config_0.8.34-1_all.deb
        dpkg -i mysql-apt-config_0.8.34-1_all.deb
    fi

    mpass=$(gen_pass)
    debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password $mpass"
    debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password $mpass"
    debconf-set-selections <<< "mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"
fi
if [ "$postgresql" = 'no' ]; then
    software=$(echo "$software" | sed -e 's/postgresql-contrib//')
    software=$(echo "$software" | sed -e 's/postgresql//')
    software=$(echo "$software" | sed -e 's/php5-pgsql//')
    software=$(echo "$software" | sed -e 's/php-pgsql//')
    software=$(echo "$software" | sed -e 's/phppgadmin//')
fi
if [ "$softaculous" = 'no' ]; then
    software=$(echo "$software" | sed -e 's/vesta-softaculous//')
fi
if [ "$iptables" = 'no' ] || [ "$fail2ban" = 'no' ]; then
    software=$(echo "$software" | sed -e 's/fail2ban//')
fi

#----------------------------------------------------------#
#                     Install Packages                     #
#----------------------------------------------------------#

# Update system packages
echo "=== Running: apt-get update"
apt-get update

echo "=== Disable daemon autostart /usr/share/doc/sysv-rc/README.policy-rc.d.gz"
echo -e '#!/bin/sh \nexit 101' > /usr/sbin/policy-rc.d
chmod a+x /usr/sbin/policy-rc.d

if [ "$mysql8" = 'yes' ]; then
    echo "=== Installing MySQL 8"
    apt-get -y install mysql-server mysql-client mysql-common
    currentservice='mysql'
    ensure_startup $currentservice
    ensure_start $currentservice
    echo -e "[client]\npassword='$mpass'\n" > /root/.my.cnf
    chmod 600 /root/.my.cnf
    mysqladmin -u root password $mpass
fi

echo "=== Installing all apt packages"
apt-get -y install $software
check_result $? "apt-get install failed"

if [ "$mysql8" = 'yes' ]; then
    if [ "$exim" = 'yes' ]; then
        echo "=== Installing exim4"
        apt-get -y install exim4 exim4-daemon-heavy
    fi
    echo "=== Installing phpmyadmin"
    apt-get -y install phpmyadmin
fi

echo "=== Enabling daemon autostart"
rm -f /usr/sbin/policy-rc.d

if [ "$release" -gt 11 ]; then
    echo "=== Setting up rsyslog"
    currentservice='rsyslog'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                     Configure System                     #
#----------------------------------------------------------#

echo "== Enable SSH password authentication"
sed -i "s/rdAuthentication no/rdAuthentication yes/g" /etc/ssh/sshd_config
systemctl restart ssh

echo "== Disable awstats cron"
rm -f /etc/cron.d/awstats

echo "== Set directory color for ls command"
echo 'LS_COLORS="$LS_COLORS:di=00;33"' >> /etc/profile

echo "== Register /sbin/nologin and /usr/sbin/nologin in /etc/shells"
echo "/sbin/nologin" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

echo "== NTP Synchronization"
echo '#!/bin/sh' > /etc/cron.daily/ntpdate
echo "$(which ntpdate) -s pool.ntp.org" >> /etc/cron.daily/ntpdate
chmod 775 /etc/cron.daily/ntpdate
ntpdate -s pool.ntp.org

if [ "$release" -eq 9 ]; then
    # Setup rssh for Debian 9
    if [ -z "$(grep /usr/bin/rssh /etc/shells)" ]; then
        echo /usr/bin/rssh >> /etc/shells
    fi
    sed -i 's/#allowscp/allowscp/' /etc/rssh.conf
    sed -i 's/#allowsftp/allowsftp/' /etc/rssh.conf
    sed -i 's/#allowrsync/allowrsync/' /etc/rssh.conf
    chmod 755 /usr/bin/rssh
fi

#----------------------------------------------------------#
#                     Configure VESTA                      #
#----------------------------------------------------------#

echo "== Installing sudo configuration"
mkdir -p /etc/sudoers.d
cp -f $vestacp/sudo/admin /etc/sudoers.d/
chmod 440 /etc/sudoers.d/admin

echo "== Configuring system environment for Vesta"
echo "export VESTA='$VESTA'" > /etc/profile.d/vesta.sh
chmod 755 /etc/profile.d/vesta.sh
source /etc/profile.d/vesta.sh
echo 'PATH=$PATH:'$VESTA'/bin' >> /root/.bash_profile
echo 'export PATH' >> /root/.bash_profile
source /root/.bash_profile

echo "== Copying logrotate configuration for Vesta logs"
cp -f $vestacp/logrotate/vesta /etc/logrotate.d/

echo "== Building directory tree and creating blank files for Vesta"
mkdir -p $VESTA/conf $VESTA/log $VESTA/ssl $VESTA/data/ips \
    $VESTA/data/queue $VESTA/data/users $VESTA/data/firewall \
    $VESTA/data/sessions
touch $VESTA/data/queue/backup.pipe $VESTA/data/queue/disk.pipe \
    $VESTA/data/queue/webstats.pipe $VESTA/data/queue/restart.pipe \
    $VESTA/data/queue/traffic.pipe $VESTA/log/system.log \
    $VESTA/log/nginx-error.log $VESTA/log/auth.log
chmod 750 $VESTA/conf $VESTA/data/users $VESTA/data/ips $VESTA/log
chmod -R 750 $VESTA/data/queue
chmod 660 $VESTA/log/*
rm -f /var/log/vesta
ln -s $VESTA/log /var/log/vesta
chmod 770 $VESTA/data/sessions

echo "== Generating vesta.conf"
rm -f $VESTA/conf/vesta.conf 2>/dev/null
touch $VESTA/conf/vesta.conf
chmod 660 $VESTA/conf/vesta.conf

# Configure Vesta web stack
if [ "$apache" = 'yes' ] && [ "$nginx" = 'no' ] ; then
    echo "WEB_SYSTEM='apache2'" >> $VESTA/conf/vesta.conf
    echo "WEB_RGROUPS='www-data'" >> $VESTA/conf/vesta.conf
    echo "WEB_PORT='80'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL_PORT='443'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL='mod_ssl'"  >> $VESTA/conf/vesta.conf
    echo "STATS_SYSTEM='webalizer,awstats'" >> $VESTA/conf/vesta.conf
fi
if [ "$apache" = 'yes' ] && [ "$nginx"  = 'yes' ] ; then
    echo "WEB_SYSTEM='apache2'" >> $VESTA/conf/vesta.conf
    echo "WEB_RGROUPS='www-data'" >> $VESTA/conf/vesta.conf
    echo "WEB_PORT='8080'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL_PORT='8443'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL='mod_ssl'"  >> $VESTA/conf/vesta.conf
    echo "PROXY_SYSTEM='nginx'" >> $VESTA/conf/vesta.conf
    echo "PROXY_PORT='80'" >> $VESTA/conf/vesta.conf
    echo "PROXY_SSL_PORT='443'" >> $VESTA/conf/vesta.conf
    echo "STATS_SYSTEM='webalizer,awstats'" >> $VESTA/conf/vesta.conf
fi
if [ "$apache" = 'no' ] && [ "$nginx"  = 'yes' ]; then
    echo "WEB_SYSTEM='nginx'" >> $VESTA/conf/vesta.conf
    echo "WEB_PORT='80'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL_PORT='443'" >> $VESTA/conf/vesta.conf
    echo "WEB_SSL='openssl'"  >> $VESTA/conf/vesta.conf
    if [ "$release" -gt 8 ]; then
        if [ "$phpfpm" = 'yes' ]; then
            echo "WEB_BACKEND='php-fpm'" >> $VESTA/conf/vesta.conf
        fi
    else
        if [ "$phpfpm" = 'yes' ]; then
            echo "WEB_BACKEND='php5-fpm'" >> $VESTA/conf/vesta.conf
        fi
    fi
    echo "STATS_SYSTEM='webalizer,awstats'" >> $VESTA/conf/vesta.conf
fi

# Configure Vesta FTP stack
if [ "$vsftpd" = 'yes' ]; then
    echo "FTP_SYSTEM='vsftpd'" >> $VESTA/conf/vesta.conf
fi
if [ "$proftpd" = 'yes' ]; then
    echo "FTP_SYSTEM='proftpd'" >> $VESTA/conf/vesta.conf
fi

# Configure Vesta DNS stack
if [ "$named" = 'yes' ]; then
    echo "DNS_SYSTEM='bind9'" >> $VESTA/conf/vesta.conf
fi

# Configure Vesta mail stack
if [ "$exim" = 'yes' ]; then
    echo "MAIL_SYSTEM='exim4'" >> $VESTA/conf/vesta.conf
    if [ "$clamd" = 'yes'  ]; then
        echo "ANTIVIRUS_SYSTEM='clamav-daemon'" >> $VESTA/conf/vesta.conf
    fi
    if [ "$spamd" = 'yes' ]; then
        if [ "$release" -lt 12 ]; then
            echo "ANTISPAM_SYSTEM='spamassassin'" >> $VESTA/conf/vesta.conf
        else
            echo "ANTISPAM_SYSTEM='spamd'" >> $VESTA/conf/vesta.conf
        fi
    fi
    if [ "$dovecot" = 'yes' ]; then
        echo "IMAP_SYSTEM='dovecot'" >> $VESTA/conf/vesta.conf
    fi
fi

# Configure Vesta cron daemon
echo "CRON_SYSTEM='cron'" >> $VESTA/conf/vesta.conf

# Configure Vesta firewall stack
if [ "$iptables" = 'yes' ]; then
    echo "FIREWALL_SYSTEM='iptables'" >> $VESTA/conf/vesta.conf
fi
if [ "$iptables" = 'yes' ] && [ "$fail2ban" = 'yes' ]; then
    echo "FIREWALL_EXTENSION='fail2ban'" >> $VESTA/conf/vesta.conf
fi

# Configure disk quota
if [ "$quota" = 'yes' ]; then
    echo "DISK_QUOTA='yes'" >> $VESTA/conf/vesta.conf
fi

# Configure backups
echo "BACKUP_SYSTEM='local'" >> $VESTA/conf/vesta.conf

# Set language
echo "LANGUAGE='$lang'" >> $VESTA/conf/vesta.conf

# Set version
echo "VERSION='0.9.8'" >> $VESTA/conf/vesta.conf

echo "== Copying packages"
cp -rf $vestacp/packages $VESTA/data/

echo "== Copying templates"
cp -rf $vestacp/templates $VESTA/data/

# Symlink missing templates for specific Debian versions
if [ "$release" -eq 10 ]; then
    echo "== Symlink missing templates for Debian 10"
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.sh /usr/local/vesta/data/templates/web/nginx/default.sh
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.tpl /usr/local/vesta/data/templates/web/nginx/default.tpl
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.stpl /usr/local/vesta/data/templates/web/nginx/default.stpl

    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh /usr/local/vesta/data/templates/web/apache2/hosting.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.tpl /usr/local/vesta/data/templates/web/apache2/hosting.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.stpl /usr/local/vesta/data/templates/web/apache2/hosting.stpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.sh /usr/local/vesta/data/templates/web/apache2/default.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.tpl /usr/local/vesta/data/templates/web/apache2/default.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-73.stpl /usr/local/vesta/data/templates/web/apache2/default.stpl
    
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.stpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-73.stpl
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.tpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-73.tpl
fi
if [ "$release" -eq 11 ]; then
    echo "== Symlink missing templates for Debian 11"
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.sh /usr/local/vesta/data/templates/web/nginx/default.sh
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.tpl /usr/local/vesta/data/templates/web/nginx/default.tpl
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.stpl /usr/local/vesta/data/templates/web/nginx/default.stpl

    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.sh /usr/local/vesta/data/templates/web/apache2/hosting.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.tpl /usr/local/vesta/data/templates/web/apache2/hosting.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.stpl /usr/local/vesta/data/templates/web/apache2/hosting.stpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.sh /usr/local/vesta/data/templates/web/apache2/default.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.tpl /usr/local/vesta/data/templates/web/apache2/default.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-74.stpl /usr/local/vesta/data/templates/web/apache2/default.stpl
    
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.stpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-74.stpl
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.tpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-74.tpl
fi
if [ "$release" -eq 12 ]; then
    echo "== Symlink missing templates for Debian 12"
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.sh /usr/local/vesta/data/templates/web/nginx/default.sh
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.tpl /usr/local/vesta/data/templates/web/nginx/default.tpl
    ln -s /usr/local/vesta/data/templates/web/nginx/hosting.stpl /usr/local/vesta/data/templates/web/nginx/default.stpl

    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.sh /usr/local/vesta/data/templates/web/apache2/hosting.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.tpl /usr/local/vesta/data/templates/web/apache2/hosting.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.stpl /usr/local/vesta/data/templates/web/apache2/hosting.stpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.sh /usr/local/vesta/data/templates/web/apache2/default.sh
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.tpl /usr/local/vesta/data/templates/web/apache2/default.tpl
    ln -s /usr/local/vesta/data/templates/web/apache2/PHP-FPM-82.stpl /usr/local/vesta/data/templates/web/apache2/default.stpl
    
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.stpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-82.stpl
    ln  -s /usr/local/vesta/data/templates/web/nginx/php-fpm/default.tpl /usr/local/vesta/data/templates/web/nginx/php-fpm/PHP-FPM-82.tpl
fi

echo "== Set nameservers address in default package"
sed -i "s/YOURHOSTNAME1/ns1.$servername/" /usr/local/vesta/data/packages/default.pkg
sed -i "s/YOURHOSTNAME2/ns2.$servername/" /usr/local/vesta/data/packages/default.pkg
sed -i "s/ns1.domain.tld/ns1.$servername/" /usr/local/vesta/data/packages/default.pkg
sed -i "s/ns2.domain.tld/ns2.$servername/" /usr/local/vesta/data/packages/default.pkg
sed -i "s/ns1.example.com/ns1.$servername/" /usr/local/vesta/data/packages/default.pkg
sed -i "s/ns2.example.com/ns2.$servername/" /usr/local/vesta/data/packages/default.pkg

echo "== Copying index.html to default documentroot"
cp $VESTA/data/templates/web/skel/public_html/index.html /var/www/
sed -i 's/%domain%/It worked!/g' /var/www/index.html

echo "== Copying firewall rules"
cp -rf $vestacp/firewall $VESTA/data/

echo "== Configuring server hostname: $servername"
$VESTA/bin/v-change-sys-hostname $servername 2>/dev/null

echo "== Generating Vesta unsigned SSL certificate"
$VESTA/bin/v-generate-ssl-cert $(hostname) $email 'US' 'California' \
     'San Francisco' 'myVesta Control Panel' 'IT' > /tmp/vst.pem

# Parse SSL certificate file
crt_end=$(grep -n "END CERTIFICATE-" /tmp/vst.pem |cut -f 1 -d:)
if [ "$release" -lt 12 ]; then
    key_start=$(grep -n "BEGIN RSA" /tmp/vst.pem |cut -f 1 -d:)
    key_end=$(grep -n  "END RSA" /tmp/vst.pem |cut -f 1 -d:)
else
    key_start=$(grep -n "BEGIN PRIVATE KEY" /tmp/vst.pem |cut -f 1 -d:)
    key_end=$(grep -n  "END PRIVATE KEY" /tmp/vst.pem |cut -f 1 -d:)
fi

cd $VESTA/ssl
sed -n "1,${crt_end}p" /tmp/vst.pem > certificate.crt
sed -n "$key_start,${key_end}p" /tmp/vst.pem > certificate.key
chown root:mail $VESTA/ssl/*
chmod 660 $VESTA/ssl/*
rm /tmp/vst.pem

#----------------------------------------------------------#
#                     Configure Nginx                      #
#----------------------------------------------------------#

if [ "$nginx" = 'yes' ]; then
    echo "=== Configure nginx"
    rm -f /etc/nginx/conf.d/*.conf
    cp -f $vestacp/nginx/nginx.conf /etc/nginx/
    cp -f $vestacp/nginx/status.conf /etc/nginx/conf.d/
    cp -f $vestacp/nginx/phpmyadmin.inc /etc/nginx/conf.d/
    if [ "$release" -lt 12 ]; then
        cp -f $vestacp/nginx/phppgadmin.inc /etc/nginx/conf.d/
    fi
    cp -f $vestacp/nginx/webmail.inc /etc/nginx/conf.d/
    cp -f $vestacp/logrotate/nginx /etc/logrotate.d/
    
    # Default user/pass for private-hosting.tpl: private / folder
    echo 'private:$apr1$0MYnchM5$yVi/OTfp7o3lGNst/a8.90' > /etc/nginx/.htpasswd
    
    echo > /etc/nginx/conf.d/vesta.conf
    mkdir -p /var/log/nginx/domains
    currentservice='nginx'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                    Configure Apache                      #
#----------------------------------------------------------#

if [ "$apache" = 'yes'  ]; then
    echo "=== Configure Apache"
    cp -f $vestacp/apache2/apache2.conf /etc/apache2/
    cp -f $vestacp/apache2/status.conf /etc/apache2/mods-enabled/
    cp -f  $vestacp/logrotate/apache2 /etc/logrotate.d/
    a2enmod rewrite
    a2enmod ssl
    a2enmod actions
    a2enmod headers
    a2enmod expires
    a2enmod proxy_fcgi setenvif
    mkdir -p /etc/apache2/conf.d
    echo > /etc/apache2/conf.d/vesta.conf
    echo "# Powered by vesta" > /etc/apache2/sites-available/default
    echo "# Powered by vesta" > /etc/apache2/sites-available/default-ssl
    echo "# Powered by vesta" > /etc/apache2/ports.conf
    touch /var/log/apache2/access.log /var/log/apache2/error.log
    mkdir -p /var/log/apache2/domains
    chmod a+x /var/log/apache2
    chmod 640 /var/log/apache2/access.log /var/log/apache2/error.log
    chmod 751 /var/log/apache2/domains
    currentservice='apache2'
    ensure_startup $currentservice
    ensure_start $currentservice
else
    systemctl disable apache2
    systemctl stop apache2
fi

#----------------------------------------------------------#
#                     Configure PHP-FPM                    #
#----------------------------------------------------------#

if [ "$phpfpm" = 'yes' ]; then
    echo "=== Configure PHP-FPM"
    if [ "$release" -eq 12 ]; then
        cp -f $vestacp/php-fpm/www.conf /etc/php/8.2/fpm/pool.d/www.conf
        currentservice='php8.2-fpm'
        ensure_startup $currentservice
        ensure_start $currentservice
    elif [ "$release" -eq 11 ]; then
        cp -f $vestacp/php-fpm/www.conf /etc/php/7.4/fpm/pool.d/www.conf
        currentservice='php7.4-fpm'
        ensure_startup $currentservice
        ensure_start $currentservice
    elif [ "$release" -eq 10 ]; then
        cp -f $vestacp/php-fpm/www.conf /etc/php/7.3/fpm/pool.d/www.conf
        currentservice='php7.3-fpm'
        ensure_startup $currentservice
        ensure_start $currentservice
    elif [ "$release" -eq 9 ]; then
        cp -f $vestacp/php-fpm/www.conf /etc/php/7.0/fpm/pool.d/www.conf
        currentservice='php7.0-fpm'
        ensure_startup $currentservice
        ensure_start $currentservice
    else
        cp -f $vestacp/php5-fpm/www.conf /etc/php5/fpm/pool.d/www.conf
        currentservice='php5-fpm'
        ensure_startup $currentservice
        ensure_start $currentservice
    fi
fi

#----------------------------------------------------------#
#                     Configure PHP                        #
#----------------------------------------------------------#

echo "=== Configure PHP timezone"
ZONE=$(timedatectl 2>/dev/null|grep Timezone|awk '{print $2}')
if [ -z "$ZONE" ]; then
    ZONE='UTC'
fi
for pconf in $(find /etc/php* -name php.ini); do
    sed -i "s/;date.timezone =/date.timezone = $ZONE/g" $pconf
done

#----------------------------------------------------------#
#                    Configure VSFTPD                      #
#----------------------------------------------------------#

if [ "$vsftpd" = 'yes' ]; then
    echo "=== Configure VSFTPD"
    cp -f $vestacp/vsftpd/vsftpd.conf /etc/
    currentservice='vsftpd'
    ensure_startup $currentservice
    ensure_start $currentservice

    # Add /sbin/nologin to /etc/shells for vsftpd (temporary fix)
    echo "/sbin/nologin" >> /etc/shells
fi

#----------------------------------------------------------#
#                    Configure ProFTPD                     #
#----------------------------------------------------------#

if [ "$proftpd" = 'yes' ]; then
    echo "=== Configure ProFTPD"
    echo "127.0.0.1 $servername" >> /etc/hosts
    cp -f $vestacp/proftpd/proftpd.conf /etc/proftpd/
    cp -f $vestacp/proftpd/tls.conf /etc/proftpd/
    currentservice='proftpd'
    ensure_startup $currentservice
    ensure_start $currentservice

    # Temporary ProFTPD fix for Debian 12
    if [ "$release" -eq 12 ]; then
        systemctl disable --now proftpd.socket
        systemctl enable --now proftpd.service
    fi
fi

#----------------------------------------------------------#
#                  Configure MySQL/MariaDB                 #
#----------------------------------------------------------#

if [ "$mysql" = 'yes' ] || [ "$mysql8" = 'yes' ]; then
    if [ "$mysql" = 'yes' ]; then
        touch $VESTA/conf/mariadb_installed
    fi
    if [ "$mysql8" = 'yes' ]; then
        touch $VESTA/conf/mysql8_installed
    fi

    if [ "$mysql" = 'yes' ]; then
        echo "=== Configure MariaDB"
        mycnf="my-small.cnf"
        if [ $memory -gt 1200000 ]; then
            mycnf="my-medium.cnf"
        fi
        if [ $memory -gt 3900000 ]; then
            mycnf="my-large.cnf"
        fi

        # Configure MySQL/MariaDB
        cp -f $vestacp/mysql/$mycnf /etc/mysql/my.cnf
        mysql_install_db
        currentservice='mysql'
        ensure_startup $currentservice
        ensure_start $currentservice

        # Secure MySQL installation
        mpass=$(gen_pass)
        mysqladmin -u root password $mpass
        echo -e "[client]\npassword='$mpass'\n" > /root/.my.cnf
        chmod 600 /root/.my.cnf
        mysql -e "DELETE FROM mysql.user WHERE User=''"
        mysql -e "DROP DATABASE test" >/dev/null 2>&1
        mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%'"
        mysql -e "DELETE FROM mysql.user WHERE user='' or password='';"
        mysql -e "FLUSH PRIVILEGES"
    fi

    # Configure phpMyAdmin
    echo "=== Configure phpMyAdmin"
    if [ "$release" -eq 10 ]; then
        mkdir /etc/phpmyadmin
        mkdir -p /var/lib/phpmyadmin/tmp
    fi
    if [ "$apache" = 'yes' ]; then
        cp -f $vestacp/pma/apache.conf /etc/phpmyadmin/
        ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf.d/phpmyadmin.conf
    fi
    cp -f $vestacp/pma/config.inc.php /etc/phpmyadmin/
    chmod 777 /var/lib/phpmyadmin/tmp
    if [ "$release" -eq 10 ]; then
        mkdir /root/phpmyadmin
        mkdir /usr/share/phpmyadmin
        
        pma_v='4.9.7'
        echo "=== Installing phpMyAdmin version v$pma_v (Debian 10 custom part)"

        cd /root/phpmyadmin

        # Download latest phpMyAdmin release
        wget -nv -O phpMyAdmin-$pma_v-all-languages.tar.gz https://files.phpmyadmin.net/phpMyAdmin/$pma_v/phpMyAdmin-$pma_v-all-languages.tar.gz

        # Unpack files
        tar xzf phpMyAdmin-$pma_v-all-languages.tar.gz

        # Delete file to prevent error
        rm -fr /usr/share/phpmyadmin/doc/html

        # Overwrite old files
        cp -rf phpMyAdmin-$pma_v-all-languages/* /usr/share/phpmyadmin

        # Set config and log directory
        sed -i "s|define('CONFIG_DIR', '');|define('CONFIG_DIR', '/etc/phpmyadmin/');|" /usr/share/phpmyadmin/libraries/vendor_config.php
        sed -i "s|define('TEMP_DIR', './tmp/');|define('TEMP_DIR', '/var/lib/phpmyadmin/tmp/');|" /usr/share/phpmyadmin/libraries/vendor_config.php

        # Create temporary folder and change permission
        mkdir /usr/share/phpmyadmin/tmp
        chmod 777 /usr/share/phpmyadmin/tmp

        # Clean up
        rm -fr phpMyAdmin-$pma_v-all-languages
        rm -f phpMyAdmin-$pma_v-all-languages.tar.gz
        
        wget -nv -O /root/phpmyadmin/pma.sh http://c.myvestacp.com/debian/10/pma/pma.sh 
        wget -nv -O /root/phpmyadmin/create_tables.sql http://c.myvestacp.com/debian/10/pma/create_tables.sql
        bash /root/phpmyadmin/pma.sh
        blowfish=$(gen_pass)
        echo "\$cfg['blowfish_secret'] = '$blowfish';" >> /etc/phpmyadmin/config.inc.php

        # Disable root login in phpMyAdmin
        echo "\$cfg['Servers'][\$i]['AllowRoot'] = FALSE;" >> /etc/phpmyadmin/config.inc.php
    fi
    if [ "$release" -gt 10 ]; then
        echo "=== Configure phpMyAdmin (Debian 11+ custom part)"
        # Set config and log directory
        sed -i "s|define('CONFIG_DIR', '');|define('CONFIG_DIR', '/etc/phpmyadmin/');|" /usr/share/phpmyadmin/libraries/vendor_config.php
        sed -i "s|define('TEMP_DIR', './tmp/');|define('TEMP_DIR', '/var/lib/phpmyadmin/tmp/');|" /usr/share/phpmyadmin/libraries/vendor_config.php

        # Create temporary folder and change permission
        mkdir /usr/share/phpmyadmin/tmp
        chmod 777 /usr/share/phpmyadmin/tmp

        mkdir /root/phpmyadmin
        wget -nv -O /root/phpmyadmin/pma.sh http://c.myvestacp.com/debian/11/pma/pma.sh 
        wget -nv -O /root/phpmyadmin/create_tables.sql http://c.myvestacp.com/debian/11/pma/create_tables.sql
        bash /root/phpmyadmin/pma.sh
        blowfish=$(gen_pass)
        echo "\$cfg['blowfish_secret'] = '$blowfish';" >> /etc/phpmyadmin/config.inc.php

        # Disable root login in phpMyAdmin
        echo "\$cfg['Servers'][\$i]['AllowRoot'] = FALSE;" >> /etc/phpmyadmin/config.inc.php
    fi
fi

#----------------------------------------------------------#
#                   Configure PostgreSQL                   #
#----------------------------------------------------------#

if [ "$postgresql" = 'yes' ]; then
    echo "=== Configure PostgreSQL"
    ppass=$(gen_pass)
    cp -f $vestacp/postgresql/pg_hba.conf /etc/postgresql/*/main/
    currentservice='postgresql'
    ensure_startup $currentservice
    ensure_start $currentservice
    sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$ppass'"

    # Configure phpPgAdmin for PostgreSQL
    if [ "$release" -lt 12 ]; then
        if [ "$apache" = 'yes' ]; then
            cp -f $vestacp/pga/phppgadmin.conf /etc/apache2/conf.d/
        fi
        cp -f $vestacp/pga/config.inc.php /etc/phppgadmin/
    fi
fi

#----------------------------------------------------------#
#                      Configure Bind                      #
#----------------------------------------------------------#

if [ "$named" = 'yes' ]; then
    echo "=== Configure Bind9"
    cp -f $vestacp/bind/named.conf /etc/bind/
    sed -i "s%listen-on%//listen%" /etc/bind/named.conf.options
    chown root:bind /etc/bind/named.conf
    chmod 640 /etc/bind/named.conf
    aa-complain /usr/sbin/named 2>/dev/null
    if [ "$apparmor" = 'yes' ];
    echo "=== Configure Bind9 (continued)"
    touch /etc/bind/rndc.key
    rndc-confgen -a -c /etc/bind/rndc.key
    chown bind:bind /etc/bind/rndc.key
    chmod 640 /etc/bind/rndc.key
    currentservice='bind9'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                      Configure Exim                      #
#----------------------------------------------------------#

if [ "$exim" = 'yes' ]; then
    echo "=== Configure Exim"
    gpasswd -a Debian-exim mail
    cp -f $vestacp/exim/exim4.conf.template /etc/exim4/
    cp -f $vestacp/exim/dnsbl.conf /etc/exim4/
    cp -f $vestacp/exim/spam-blocks.conf /etc/exim4/
    cp -f $vestacp/exim/deny_senders /etc/exim4/
    touch /etc/exim4/white-blocks.conf
    touch /etc/exim4/limit_per_email_account_max_sent_emails_per_hour
    touch /etc/exim4/limit_per_email_account_max_recipients
    touch /etc/exim4/limit_per_hosting_account_max_sent_emails_per_hour
    touch /etc/exim4/limit_per_hosting_account_max_recipients

    if [ "$spamd" = 'yes' ]; then
        sed -i "s/#SPAM/SPAM/g" /etc/exim4/exim4.conf.template
    fi
    if [ "$clamd" = 'yes' ]; then
        sed -i "s/#CLAMD/CLAMD/g" /etc/exim4/exim4.conf.template
    fi

    # Generate SRS key for Exim (code adapted from HestiaCP)
    srs=$(gen_pass 16)
    echo $srs > /etc/exim4/srs.conf
    chmod 640 /etc/exim4/srs.conf
    chown root:Debian-exim /etc/exim4/srs.conf

    # Set primary_hostname in exim4.conf.template (previously derived)
    sed -i "/# primary_hostname = mail.domain.com/a primary_hostname = $exim_hostname" /etc/exim4/exim4.conf.template

    chmod 640 /etc/exim4/exim4.conf.template
    rm -rf /etc/exim4/domains
    mkdir -p /etc/exim4/domains

    # Remove conflicting MTAs and set Exim as default
    rm -f /etc/alternatives/mta
    ln -s /usr/sbin/exim4 /etc/alternatives/mta
    update-rc.d -f sendmail remove > /dev/null 2>&1
    service sendmail stop > /dev/null 2>&1
    update-rc.d -f postfix remove > /dev/null 2>&1
    service postfix stop > /dev/null 2>&1

    currentservice='exim4'
    ensure_startup $currentservice
    systemctl restart $currentservice
fi

#----------------------------------------------------------#
#                    Configure Dovecot                     #
#----------------------------------------------------------#

if [ "$dovecot" = 'yes' ]; then
    echo "=== Configure Dovecot"
    gpasswd -a dovecot mail
    cp -f $vestacp/dovecot/dovecot.conf /etc/dovecot/
    cp -f $vestacp/dovecot/conf.d/* /etc/dovecot/conf.d/
    if [ "$release" -eq 8 ]; then
        sed -i "s/\/var\/spool\/postfix\/private\/auth/\/var\/spool\/postfix\/private\/dovecot-auth/g" /etc/dovecot/conf.d/10-master.conf
    fi
    chown -R dovecot:dovecot /etc/dovecot
    chmod -R go-r /etc/dovecot
    currentservice='dovecot'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                     Configure ClamAV                     #
#----------------------------------------------------------#

if [ "$clamd" = 'yes' ]; then
    echo "=== Configure ClamAV"
    gpasswd -a clamav mail
    cp -f $vestacp/clamav/clamd.conf /etc/clamav/clamd.conf
    if [ ! -d "/var/run/clamav" ]; then
        mkdir /var/run/clamav
        chown clamav:clamav /var/run/clamav
    fi
    if [ "$release" -eq 8 ]; then
        sed -i "s/AllowSupplementaryGroups false/AllowSupplementaryGroups true/g" /etc/clamav/clamd.conf
    fi
    currentservice='clamav-daemon'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                   Configure SpamAssassin                 #
#----------------------------------------------------------#

if [ "$spamd" = 'yes' ]; then
    echo "=== Configure SpamAssassin"
    cp -f $vestacp/spamassassin/local.cf /etc/spamassassin/
    if [ "$release" -gt 10 ]; then
        cp -f $vestacp/spamassassin/spamassassin /etc/default/
    else
        cp -f $vestacp/spamassassin/spamassassin_debian10 /etc/default/spamassassin
    fi
    update-rc.d spamassassin enable
    if [ "$release" -lt 12 ]; then
        currentservice='spamassassin'
        ensure_startup $currentservice
        ensure_start $currentservice
    else
        currentservice='spamd'
        ensure_startup $currentservice
        ensure_start $currentservice
    fi
fi

#----------------------------------------------------------#
#                    Configure Roundcube                   #
#----------------------------------------------------------#

if [ "$exim" = 'yes' ] && [ "$mysql" = 'yes' ]; then
    echo "=== Configure Roundcube"
    if [ "$release" -eq 10 ]; then
        mkdir -p /usr/share/roundcube
        mkdir -p /var/log/roundcube
        mkdir -p /etc/roundcube

        rdc_v='1.4.15'
        echo "=== Installing Roundcube version v$rdc_v (Debian 10 custom part)"

        cd /root

        # Download latest Roundcube release
        wget -nv -O roundcubemail-$rdc_v-complete.tar.gz https://github.com/roundcube/roundcubemail/releases/download/$rdc_v/roundcubemail-$rdc_v-complete.tar.gz

        # Unpack files
        tar xzf roundcubemail-$rdc_v-complete.tar.gz

        # Delete file to prevent error
        rm -fr /usr/share/roundcube/doc/html

        # Overwrite old files
        cp -rf roundcubemail-$rdc_v/* /usr/share/roundcube

        # Create temporary folder and change permission
        mkdir /usr/share/roundcube/temp
        chmod 777 /usr/share/roundcube/temp

        # Clean up
        rm -fr roundcubemail-$rdc_v
        rm -f roundcubemail-$rdc_v-complete.tar.gz
        
        wget -nv -O /root/roundcube.sh http://c.myvestacp.com/debian/10/roundcube/roundcube.sh
        bash /root/roundcube.sh
        cp -f $vestacp/roundcube/main.inc.php /etc/roundcube/config.inc.php
        cp -f $vestacp/roundcube/db.inc.php /etc/roundcube/
        if [ "$apache" = 'yes' ]; then
            cp -f $vestacp/roundcube/apache.conf /etc/roundcube/
            ln -s /etc/roundcube/apache.conf /etc/apache2/conf.d/roundcube.conf
        fi
    fi
    if [ "$release" -gt 10 ]; then
        echo "=== Configure Roundcube (Debian 11+ custom part)"
        wget -nv -O /root/roundcube.sh http://c.myvestacp.com/debian/11/roundcube/roundcube.sh
        bash /root/roundcube.sh
        cp -f $vestacp/roundcube/main.inc.php /etc/roundcube/config.inc.php
        cp -f $vestacp/roundcube/db.inc.php /etc/roundcube/
        if [ "$apache" = 'yes' ]; then
            cp -f $vestacp/roundcube/apache.conf /etc/roundcube/
            ln -s /etc/roundcube/apache.conf /etc/apache2/conf.d/roundcube.conf
        fi
    fi
fi

#----------------------------------------------------------#
#                    Configure Fail2Ban                    #
#----------------------------------------------------------#

if [ "$iptables" = 'yes' ] && [ "$fail2ban" = 'yes' ]; then
    echo "=== Configure Fail2Ban"
    cp -rf $vestacp/fail2ban/* /etc/fail2ban/
    if [ "$dovecot" = 'yes' ]; then
        cat $vestacp/fail2ban/dovecot.conf >> /etc/fail2ban/jail.local
    fi
    currentservice='fail2ban'
    ensure_startup $currentservice
    ensure_start $currentservice
fi

#----------------------------------------------------------#
#                    Configure Iptables                    #
#----------------------------------------------------------#

if [ "$iptables" = 'yes' ]; then
    echo "=== Configure iptables"
    cp -f $vestacp/iptables/iptables.rules /etc/
    cp -f $vestacp/iptables/ip6tables.rules /etc/
    if [ "$release" -eq 8 ]; then
        cp -f $vestacp/iptables/iptables.init /etc/init.d/iptables
        chmod +x /etc/init.d/iptables
        update-rc.d iptables defaults
        /etc/init.d/iptables start
    else
        systemctl enable iptables
        systemctl enable ip6tables
        systemctl start iptables
        systemctl start ip6tables
    fi
fi

#----------------------------------------------------------#
#                   Configure Softaculous                  #
#----------------------------------------------------------#

if [ "$softaculous" = 'yes' ]; then
    echo "=== Configure Softaculous"
    mkdir /usr/local/vesta/softaculous
    mkdir /var/vesta-softaculous
    cd /var/vesta-softaculous
    wget -nv http://www.softaculous.com/ins/install.sh
    chmod +x install.sh
    ./install.sh
    touch /usr/local/vesta/conf/vesta_softaculous
fi

#----------------------------------------------------------#
#                   Configure Disk Quota                   #
#----------------------------------------------------------#

if [ "$quota" = 'yes' ]; then
    echo "=== Configure disk quota"
    if [ -e "/etc/fstab" ]; then
        if [ -z "$(grep usrjquota /etc/fstab)" ]; then
            sed -i 's/\( \/ \+\w\+ \+\w\+ \+\)\(defaults\)\( \+\)/\1defaults,usrjquota=quota.user,grpjquota=quota.group,jqfmt=vfsv0\3/' /etc/fstab
            mount -o remount /
        fi
        touch /quota.user /quota.group
        chmod 660 /quota.user /quota.group
        quotacheck -avug
        quotaon -uv /
    fi
fi

#----------------------------------------------------------#
#                  Configure File Manager                  #
#----------------------------------------------------------#

echo "=== Configure File Manager"
$VESTA/bin/v-add-sys-filemanager quiet

#----------------------------------------------------------#
#                   Configure API                          #
#----------------------------------------------------------#

echo "== Enable API access"
$VESTA/bin/v-change-sys-api on quiet

#----------------------------------------------------------#
#                  Configure AppArmor                      #
#----------------------------------------------------------#

if [ "$apparmor" = 'yes' ]; then
    echo "=== Configure AppArmor"
    aa-complain /usr/sbin/mysqld 2>/dev/null
    aa-complain /usr/sbin/named 2>/dev/null
    aa-complain /usr/sbin/tcpdump 2>/dev/null
    aa-complain /usr/sbin/apache2 2>/dev/null
    aa-complain /sbin/klogd 2>/dev/null
    aa-complain /sbin/syslogd 2>/dev/null
    aa-complain /usr/sbin/vsftpd 2>/dev/null
fi

#----------------------------------------------------------#
#                    Configure CRON                        #
#----------------------------------------------------------#

echo "=== Configure CRON jobs"
$VESTA/bin/v-add-cron-vesta-job quiet

#----------------------------------------------------------#
#                    Configure Admin                       #
#----------------------------------------------------------#

echo "== Adding default admin account"
$VESTA/bin/v-add-user admin $vpass $email default $servername
check_result $? "can't create admin user"
$VESTA/bin/v-change-user-shell admin nologin
$VESTA/bin/v-change-sys-service-config $port $VESTA/conf/vesta.conf
$VESTA/bin/v-change-user-language admin $lang quiet
if [ ! -z "$secret_url" ]; then
    $VESTA/bin/v-add-sys-secreturl $secret_url quiet
fi

echo "== Adding default domain"
$VESTA/bin/v-add-domain admin $servername
check_result $? "can't create $servername domain"

# Set primary_hostname in exim4.conf.template for admin domain
if [ "$exim" = 'yes' ]; then
    sed -i "/# primary_hostname = mail.domain.com/a primary_hostname = $exim_hostname" /etc/exim4/exim4.conf.template
    systemctl restart exim4
fi

if [ "$named" = 'yes' ]; then
    echo "== Adding ns1 and ns2 A records"
    /usr/local/vesta/bin/v-add-dns-record 'admin' "$servername" 'ns1' 'A' "$pub_ip"
    /usr/local/vesta/bin/v-add-dns-record 'admin' "$servername" 'ns2' 'A' "$pub_ip"
fi

#----------------------------------------------------------#
#                    Configure IP                          #
#----------------------------------------------------------#

echo "== Adding default IP address"
pub_ip=$(curl --connect-timeout 5 --retry 3 -s $CHOST/tools/myip.php)
if [ -z "$pub_ip" ]; then
    pub_ip=$(curl --connect-timeout 5 --retry 3 -s http://ipecho.net/plain)
fi
if [ -z "$pub_ip" ]; then
    pub_ip=$(ip addr|grep 'inet '|grep global|head -n1|awk '{print $2}'|cut -f1 -d/)
fi
$VESTA/bin/v-add-sys-ip $pub_ip 255.255.255.255

#----------------------------------------------------------#
#                 Configure Softaculous                     #
#----------------------------------------------------------#

if [ "$softaculous" = 'yes' ]; then
    echo "=== Configure Softaculous for admin"
    $VESTA/bin/v-add-user-softaculous admin
fi

#----------------------------------------------------------#
#                    Configure SNI                         #
#----------------------------------------------------------#

if [ "$nginx" = 'yes' ]; then
    echo "== Enable SNI support for nginx"
    $VESTA/bin/v-add-sys-sni
fi

#----------------------------------------------------------#
#                    Finalize Setup                        #
#----------------------------------------------------------#

echo "== Update Vesta configuration"
$VESTA/bin/v-update-sys-rrd
$VESTA/bin/v-update-sys-queue disk
$VESTA/bin/v-update-sys-queue traffic
$VESTA/bin/v-update-sys-queue webstats
$VESTA/bin/v-update-sys-queue backup

#----------------------------------------------------------#
#                    Installation Complete                 #
#----------------------------------------------------------#

# Display installation summary
echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
echo "                __     __        _        "
echo "  _ __ ___  _   \ \   / /__  ___| |_ __ _ "
echo " | '_ \` _ \| | | \ \ / / _ \/ __| __/ _\` |"
echo " | | | | | | |_| |\ V /  __/\__ \ || (_| |"
echo " |_| |_| |_|\__, | \_/ \___||___/\__\__,_|"
echo "            |___/                         "
echo
echo "                                myVesta Control Panel"
echo -e "\n\n"
echo "Congratulations,"
echo "myVesta has been successfully installed on your server."
echo -e "\n"
echo "Please take a moment and visit https://myvestacp.com/after-install/ to see what you should do after installation"
echo -e "\n"
if [ ! -z "$secret_url" ]; then
    echo "Access hosting panel at: https://$servername:$port/$secret_url/"
else
    echo "Access hosting panel at: https://$servername:$port/"
fi
echo "Username: admin"
echo "Password: $vpass"
echo -e "\n"
if [ "$mysql" = 'yes' ] || [ "$mysql8" = 'yes' ]; then
    echo "MySQL Username: root"
    echo "MySQL Password: $mpass"
    echo -e "\n"
fi
if [ "$postgresql" = 'yes' ]; then
    echo "PostgreSQL Username: postgres"
    echo "PostgreSQL Password: $ppass"
    echo -e "\n"
fi
echo "Don't forget above credentials, because they won't be stored anywhere except in this output."
echo -e "\n"
echo "If you liked myVesta, please consider donating at https://myvestacp.com/donate/"
echo "Thank you for choosing myVesta!"
echo -e "\n\n"

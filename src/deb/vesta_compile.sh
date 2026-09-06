#!/bin/bash

# Autocompile script for myVesta deb files - ver 1.1
# Autocompile script borrowed from HestiaCP, special thanks to Raphael Schneeberger

build_deb_package=1
add_deb_to_apt_repo=0

TARGET_DEB_NAME=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)
TARGET_DEB_VER=$(cat /etc/debian_version | tr "." "\n" | head -n1)

run_apt_update_and_install=1
wait_to_press_enter=1

###############
# Note: first run --apt before turning add_deb_to_apt_repo=1

if [ $# -gt 1 ]; then
    TARGET_DEB_NAME=$2
fi
if [ $# -gt 2 ]; then
    TARGET_DEB_VER=$3
fi
if [ $# -gt 3 ]; then
    build_deb_package=$4
fi
if [ $# -gt 4 ]; then
    add_deb_to_apt_repo=$5
fi

MAINTAINER_EMAIL='info@myvestacp.com'

TARGET_DEB_NAME_MAIN=$(grep '^VERSION_CODENAME=' /etc/os-release | cut -d= -f2)
TARGET_DEB_VER_MAIN=$(cat /etc/debian_version | tr "." "\n" | head -n1)

# Set compiling directory
BUILD_DIR="/usr/src/$TARGET_DEB_NAME"
BUILD_DIR_MAIN="/usr/src/$TARGET_DEB_NAME_MAIN"
INSTALL_DIR="/usr/local/vesta"

# Set git repository raw path
GIT_SRC='https://raw.githubusercontent.com/myvesta/vesta/master/src'
GIT_REP="$GIT_REP/deb"

C_WEB_ADDRESS="c.myvestacp.com"
WWW_FOLDER="/var/www"
PATH_OF_C_WEB_FOLDER_ROOT="$WWW_FOLDER/$C_WEB_ADDRESS/html"
PATH_OF_C_WEB_FOLDER="$PATH_OF_C_WEB_FOLDER_ROOT/debian/$TARGET_DEB_VER"
APT_WEB_ADDRESS="apt.myvestacp.com"
PATH_OF_APT_REPO_ROOT="$WWW_FOLDER/$APT_WEB_ADDRESS/html"
PATH_OF_APT_REPO="$PATH_OF_APT_REPO_ROOT/$TARGET_DEB_NAME"

VESTA_VER=$(curl -s https://raw.githubusercontent.com/myvesta/vesta/master/src/deb/latest.txt)
VESTA_VER=${VESTA_VER:6}

BUILD_DATE=$(date +"%d-%b-%Y")

# Set Version for compiling
VESTA_V=$VESTA_VER"_amd64"

NGINX_V='1.31.5'
PHP_V='8.5.10'
OPENSSL_V='1.1.1w'
PCRE_V='8.45'
ZLIB_V='1.3.2'
ONIG_V='6.9.10'

VESTA_NGINX_V="$NGINX_V"
VESTA_PHP_V="$PHP_V"

# Generate Links for sourcecode
NGINX='https://nginx.org/download/nginx-'$NGINX_V'.tar.gz'
OPENSSL='https://www.openssl.org/source/openssl-'$OPENSSL_V'.tar.gz'
# PRCE got moved to sourceforce.net
# PRCE2 in the feature use 
# PCRE='https://github.com/PCRE2Project/pcre2/releases/download/pcre2-'$PCRE_V'/pcre2-'$PCRE_V'.tar.gz'
PCRE='https://sourceforge.net/projects/pcre/files/pcre/'$PCRE_V'/pcre-'$PCRE_V'.tar.gz/download'
# Zlib moved archives to Github
ZLIB='https://github.com/madler/zlib/archive/refs/tags/v'$ZLIB_V'.tar.gz'
PHP='https://www.php.net/distributions/php-'$PHP_V'.tar.gz'

# Set package dependencies for compiling
release=$(cat /etc/debian_version | tr "." "\n" | head -n1)

if [ "$release" -lt 12 ]; then
    SOFTWARE='build-essential libxml2-dev libz-dev libcurl4-gnutls-dev unzip openssl libssl-dev pkg-config reprepro dpkg-sig git rsync'
else
    SOFTWARE='build-essential libxml2-dev libz-dev libcurl4-gnutls-dev unzip openssl libssl-dev pkg-config reprepro git rsync'
fi

function press_enter {
    if [ $wait_to_press_enter -eq 1 ]; then
        read -p "$1"
    else
        echo $1
    fi
}

function make_deb_package {
  if [ -z "$2" ]; then
    VER=$VESTA_V
  else
    VER=$2
  fi
  press_enter "=== Press enter to build the package"
  echo "=== Changing to build directory: $BUILD_DIR"
  cd $BUILD_DIR
  if [ -f "$1_$VER.deb" ]; then
    echo "=== Removing existing deb file: $1_$VER.deb"
    rm $1_$VER.deb
  fi
  echo "=== Building deb package: $1_$VER.deb"
  dpkg-deb --build $1_$VER
  echo "=== Building done."
  echo "=== Your .deb package is here: $BUILD_DIR/$1_$VER.deb"
}

function add_to_repo {  
  if [ -z "$2" ]; then
    VER=$VESTA_V
  else
    VER=$2
  fi
  press_enter "=== Press enter to sign the package ==============================================================================="
  echo "=== Changing to build directory: $BUILD_DIR"
  cd $BUILD_DIR
  echo "=== Signing deb package: $1_$VER.deb"
  export GPG_TTY=$(tty)
  dpkg-sig --sign builder $1_$VER.deb
  
  press_enter "=== Press enter to add to repo ==============================================================================="
    
  echo "=== Creating apt repo directory: $PATH_OF_APT_REPO"
  mkdir -p $PATH_OF_APT_REPO

  echo "=== Changing to apt repo directory: $PATH_OF_APT_REPO"
  cd $PATH_OF_APT_REPO

  echo "=== Removing existing deb package: $1_$VER.deb from $TARGET_DEB_NAME"
  reprepro --ask-passphrase -Vb . remove $TARGET_DEB_NAME $1

  echo "=== Adding deb package: $1_$VER.deb to $TARGET_DEB_NAME"
  reprepro --ask-passphrase -Vb . includedeb $TARGET_DEB_NAME $BUILD_DIR/$1_$VER.deb

  echo "=== All done for adding to apt repo: $1_$VER.deb"
}

# Install needed software
if [ $run_apt_update_and_install -eq 1 ]; then
  echo "Update system repository..."
  
  apt-get -qq update
  echo "Installing dependencies for compilation..."
  apt-get -qq install -y $SOFTWARE
  
  # Fix for Debian PHP Envroiment
  if [ ! -e /usr/local/include/curl ] && [ "$release" -lt 12 ]; then
      ln -s /usr/include/x86_64-linux-gnu/curl /usr/local/include/curl
  fi
  if [ ! -e /usr/local/include/curl ] && [ "$release" -eq 13 ]; then
      ln -s /usr/include/x86_64-linux-gnu/curl /usr/local/include/curl
  fi
  press_enter "=== Press enter to continue ==============================================================================="
fi


# Set packages to compile
for arg; do
  case "$1" in
    --all)
      NGINX_B='true'
      PHP_B='true'
      VESTA_B='true'
      VESTAGIT_B='true'
      CWEB_B='true'
      APTWEB_B='true'
      ;;
    --nginx)
      NGINX_B='true'
      ;;
    --php)
      PHP_B='true'
      ;;
    --vesta)
      VESTA_B='true'
      ;;
    --git)
      VESTAGIT_B='true'
      ;;
    --git)
      VESTAGIT_B='true'
      ;;
    --c)
      CWEB_B='true'
      ;;
    --apt)
      APTWEB_B='true'
      ;;
    *)
      NOARGUMENT='true'
      ;;
  esac
done

if [ $# -eq 0 ]; then
  echo "!!! Please run with argument --vesta, --nginx, --php, --git, --c, --apt or --all"
  exit 1
fi

if [ -d "$WWW_FOLDER" ]; then
  if [ ! -d "/root/backup-www" ]; then
      mkdir /root/backup-www
  fi
  echo "=== Making backup of $WWW_FOLDER"
  rsync -a --delete $WWW_FOLDER/ /root/backup-www/
fi

if [ $build_deb_package -eq 1 ]; then
  if [ "$APTWEB_B" = true ]; then
    VESTAGIT_B='true'
  fi
  if [ "$CWEB_B" = true ]; then
    VESTAGIT_B='true'
  fi
  if [ "$VESTA_B" = true ]; then
    VESTAGIT_B='true'
  fi
  if [ "$PHP_B" = true ]; then
    VESTAGIT_B='true'
  fi
  if [ "$NGINX_B" = true ]; then
    VESTAGIT_B='true'
  fi
  
  if [ "$CWEB_B" = true ]; then
    if [ $# -gt 1 ]; then
      if [ $2 = "--nogit" ]; then
        VESTAGIT_B='false'
      fi
    fi
  fi

fi

if [ ! -d "$BUILD_DIR" ]; then
  mkdir -p $BUILD_DIR
fi

#################################################################################
#
# Get latest vesta from git
#
#################################################################################

if [ "$VESTAGIT_B" = true ]; then
  echo "======= Get latest vesta from git ======="
  if [ -d "/root/vesta" ]; then
    cd /root/vesta
    git pull
    if [ "$?" -ne 0 ]; then
      cd /root
      rm -rf vesta/
      git clone https://github.com/myvesta/vesta.git
      echo "=== Git cloning done"
    fi
  else
    cd /root
    git clone https://github.com/myvesta/vesta.git
  fi
fi

#################################################################################
#
# Building c subdomain web folder
#
#################################################################################

if [ "$APTWEB_B" = true ]; then
  echo "======= Building apt subdomain web folder ======="

  mkdir -p $PATH_OF_APT_REPO
  cd $PATH_OF_APT_REPO
  
  mkdir conf && cd conf
  cat <<EOF >distributions
Origin: $APT_WEB_ADDRESS
Label: myvesta apt repository
Codename: $TARGET_DEB_NAME
Architectures: amd64 source
Components: vesta
Description: myvesta debian package repo
SignWith: yes
Pull: $TARGET_DEB_NAME
EOF
  
  if [ ! -d "/root/.gnupg" ]; then
    gpg --full-gen-key
    gpg --armor --export $MAINTAINER_EMAIL --output $MAINTAINER_EMAIL.gpg.key
    press_enter "*** please copy above generated key to your clipboard and then paste it after pressing enter now ***"
    vi $PATH_OF_APT_REPO_ROOT/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/13/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/12/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/11/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/10/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/9/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/8/deb_signing.key
    cp $PATH_OF_APT_REPO_ROOT/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/debian/7/deb_signing.key
  fi

  echo "=== All done"
fi
 
#################################################################################
#
# Building c subdomain web folder
#
#################################################################################

if [ "$CWEB_B" = true ]; then
  echo "======= Building c subdomain web folder ======="
  
  echo "Removing: $PATH_OF_C_WEB_FOLDER_ROOT"
  rm -rf $PATH_OF_C_WEB_FOLDER_ROOT
  echo "=== Whole C folder removed"

  echo "=== Making folder $PATH_OF_C_WEB_FOLDER_ROOT"
  mkdir -p $PATH_OF_C_WEB_FOLDER_ROOT
  cd $PATH_OF_C_WEB_FOLDER_ROOT
  
  echo "=== Copying and extracting static files"

  cp /root/vesta/src/static.tar.gz $PATH_OF_C_WEB_FOLDER_ROOT/static.tar.gz
  tar -xzf static.tar.gz
  rm static.tar.gz
  
  echo "=== Copying files"
  mkdir -p $PATH_OF_C_WEB_FOLDER
  cp -rf /root/vesta/install/debian/* $PATH_OF_C_WEB_FOLDER_ROOT/debian
  if [ ! -f "$PATH_OF_C_WEB_FOLDER_ROOT/deb_signing.key" ]; then
    cp /root/vesta/install/debian/$TARGET_DEB_VER_MAIN/deb_signing.key $PATH_OF_C_WEB_FOLDER_ROOT/deb_signing.key
  fi
  cp /root/vesta/src/deb/latest.txt $PATH_OF_C_WEB_FOLDER_ROOT/latest.txt
  echo "$BUILD_DATE" > $PATH_OF_C_WEB_FOLDER_ROOT/build_date.txt

  if [ -f "/root/custom_callback.sh" ]; then
    BUILD_RELEASE=$(</root/vesta/src/deb/latest.txt)
    BUILD_RELEASE=${BUILD_RELEASE:6}
    bash /root/custom_callback.sh "$BUILD_RELEASE" "$BUILD_DATE" "/root/vesta/Changelog.md"
  fi

  ###########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/8

  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/

  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/

  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/

  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/

  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian8"
  ###########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/9

  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/

  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/

  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/

  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/

  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian9"
  ###########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/10

  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/

  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/

  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/

  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/

  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian10"
  ##########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/11
  
  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/
  
  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/
  
  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/

  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/

  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian11"
  ##########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/12
  
  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/
  
  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/
  
  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/
  
  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/
  
  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian12"
  ##########
  cd $PATH_OF_C_WEB_FOLDER_ROOT/debian/13
  
  if [ -f "packages.tar.gz" ]; then
    rm packages.tar.gz
  fi
  tar -czf packages.tar.gz packages/
  
  if [ -f "templates.tar.gz" ]; then
    rm templates.tar.gz
  fi
  tar -czf templates.tar.gz templates/
  
  if [ -f "firewall.tar.gz" ]; then
    rm firewall.tar.gz
  fi
  tar -czf firewall.tar.gz firewall/
  
  if [ -f "fail2ban.tar.gz" ]; then
    rm fail2ban.tar.gz
  fi
  tar -czf fail2ban.tar.gz fail2ban/
  
  if [ -f "dovecot.tar.gz" ]; then
    rm dovecot.tar.gz
  fi
  tar -czf dovecot.tar.gz dovecot/
  echo "=== All done for Debian13"
  ##########
  
  cp /root/vesta/install/vst-install-debian.sh $PATH_OF_C_WEB_FOLDER_ROOT/vst-install-debian.sh

  mkdir $PATH_OF_C_WEB_FOLDER_ROOT/tools
  cp -rf /root/vesta/src/deb/for-download/tools/* $PATH_OF_C_WEB_FOLDER_ROOT/tools

  echo "=== All done for c subdomain ==="
fi

#################################################################################
#
# Building vesta-nginx
#
#################################################################################

if [ "$NGINX_B" = true ]; then
  if [ $build_deb_package -eq 1 ]; then
    echo "======= Building vesta-nginx ======="
    
    echo "=== Change to build directory: $BUILD_DIR"
    cd $BUILD_DIR
    
    BUILDING_NOW=0
    # Check if target directory exist
    if [ ! -d "$BUILD_DIR/nginx-$NGINX_V" ] || [ ! -d "$INSTALL_DIR/nginx" ]; then
      BUILDING_NOW=1
      
      press_enter "=== Press enter to download and unpack source files"
    
      echo "=== Removing existing nginx directory: nginx-$NGINX_V"
      rm -rf nginx-$NGINX_V
      echo "=== Removing existing openssl directory: openssl-$OPENSSL_V"
      rm -rf openssl-$OPENSSL_V
      echo "=== Removing existing pcre directory: pcre-$PCRE_V"
      rm -rf pcre-$PCRE_V
      echo "=== Removing existing zlib directory: zlib-$ZLIB_V"
      rm -rf zlib-$ZLIB_V
      if [ ! -d "nginx-$NGINX_V" ]; then
        echo "=== Downloading nginx source files from $NGINX and extracting it"
        wget -nv -qO- $NGINX | tar xz
      fi
      if [ ! -d "openssl-$OPENSSL_V" ]; then
        echo "=== Downloading openssl source files from $OPENSSL and extracting it"
        wget -nv -qO- $OPENSSL | tar xz
      fi
      if [ ! -d "pcre-$PCRE_V" ]; then
        echo "=== Downloading pcre source files from $PCRE and extracting it"
        wget -nv -qO- $PCRE | tar xz
      fi
      if [ ! -d "zlib-$ZLIB_V" ]; then
        echo "=== Downloading zlib source files from $ZLIB and extracting it"
        wget -nv -qO- $ZLIB | tar xz
      fi
      
      echo "=== Change to nginx directory to: nginx-$NGINX_V"
      cd nginx-$NGINX_V
      
      press_enter "=== Press enter to configure nginx"
      echo "=== Configuring nginx"
      ./configure     --prefix=$INSTALL_DIR/nginx \
              --with-http_ssl_module \
              --with-openssl=../openssl-$OPENSSL_V \
              --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
              --with-openssl-opt=no-nextprotoneg \
              --with-openssl-opt=no-weak-ssl-ciphers \
              --with-openssl-opt=no-ssl3 \
              --with-pcre=../pcre-$PCRE_V \
              --with-pcre-jit \
              --with-zlib=../zlib-$ZLIB_V
      
      # Check install directory and remove if exists
      if [ -d "$INSTALL_DIR/nginx" ]; then
          echo "=== Removing existing nginx directory: $INSTALL_DIR/nginx"
          rm -rf $INSTALL_DIR/nginx
      fi
      
      press_enter "=== Press enter to make && make install"
      echo "=== Making (building) nginx"
      make && make install
    
    fi
    
    press_enter "=== Press enter to Prepare Deb Package Folder Structure"
    if [ -d "$BUILD_DIR/vesta-nginx_$VESTA_NGINX_V" ]; then
      echo "=== Removing existing vesta-nginx directory: $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V"
      rm -rf $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V
    fi
    echo "=== Creating directory: $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V"
    mkdir $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V
    
    echo "=== Changing to directory: $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V"
    cd $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/
    echo "=== Creating directories: usr/local/vesta/nginx etc/init.d and DEBIAN"
    mkdir -p usr/local/vesta/nginx etc/init.d DEBIAN
    
    press_enter "=== Press enter to Download control, postinst and postrm files"
    echo "=== Copying control, postinst and postrm files to $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN"
    # Copying control, postinst and postrm files
    cp -rf /root/vesta/src/deb/nginx/* $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN
    
    # Set version
    echo "=== Setting version: $VESTA_NGINX_V in $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN/control"
    sed -i "/Version: /c\Version: $VESTA_NGINX_V" $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN/control
    
    # Set permission
    echo "=== Setting permission: +x for $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN/postinst"
    chmod +x $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/DEBIAN/postinst
    
    echo "=== Copying $INSTALL_DIR/nginx/* files to usr/local/vesta/nginx"
    cp -rf $INSTALL_DIR/nginx/* usr/local/vesta/nginx
    
    echo "=== Changing to directory: $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/etc/init.d"
    cd $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/etc/init.d
    echo "=== Copying vesta service file to $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/etc/init.d/vesta"
    cp /root/vesta/src/deb/for-download/nginx/vesta vesta
    echo "=== Setting permission: +x for $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/etc/init.d/vesta"
    chmod +x vesta
    
    echo "=== Changing to directory: $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V"
    cd $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V
    if [ "$release" -lt 10 ]; then
       echo "=== Copying /root/vesta/src/deb/for-download/nginx/nginx.conf to $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/conf/nginx.conf"
      cp /root/vesta/src/deb/for-download/nginx/nginx.conf $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/conf/nginx.conf
    else
      echo "=== Copying /root/vesta/src/deb/for-download/nginx/nginx-deb12.conf to $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/conf/nginx.conf"
      cp /root/vesta/src/deb/for-download/nginx/nginx-deb12.conf $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/conf/nginx.conf
    fi
    
    # if [ $BUILDING_NOW -eq 1 ]; then
    echo "=== Copying $INSTALL_DIR/nginx/sbin/nginx to $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/sbin/vesta-nginx"
    cp $INSTALL_DIR/nginx/sbin/nginx $BUILD_DIR/vesta-nginx_$VESTA_NGINX_V/usr/local/vesta/nginx/sbin/vesta-nginx
    # fi
    
    echo "=== Making deb package: vesta-nginx_$VESTA_NGINX_V"
    make_deb_package "vesta-nginx" "$VESTA_NGINX_V"
  fi
  if [ $add_deb_to_apt_repo -eq 1 ]; then
    echo "=== Adding deb to apt repo: vesta-nginx_$VESTA_NGINX_V"
    add_to_repo "vesta-nginx" "$VESTA_NGINX_V"
  fi

  echo "=== All done for vesta-nginx_$VESTA_NGINX_V"
fi

#################################################################################
#
# Building vesta-php
#
#################################################################################


if [ "$PHP_B" = true ]; then
  if [ $build_deb_package -eq 1 ]; then
    echo "======= Building vesta-php package ======="
    cd $BUILD_DIR
    
    BUILDING_NOW=0

    if [ ! -d "onig-$ONIG_V" ]; then
      press_enter "=== Press enter to download and extract Oniguruma source files"
      BUILDING_NOW=1
      if [ ! -f "onig-$ONIG_V.tar.gz" ]; then
        echo "=== Downloading Oniguruma source files from https://github.com/kkos/oniguruma/releases/download/v$ONIG_V/onig-$ONIG_V.tar.gz"
        wget "https://github.com/kkos/oniguruma/releases/download/v$ONIG_V/onig-$ONIG_V.tar.gz" -O onig-$ONIG_V.tar.gz
      fi

      echo "=== Extracting Oniguruma source files: onig-$ONIG_V.tar.gz"
      tar xzf onig-$ONIG_V.tar.gz

      echo "=== Changing to directory: onig-$ONIG_V"
      cd onig-$ONIG_V

      press_enter "=== Press enter to configure Oniguruma"

      echo "=== Configuring Oniguruma"
      ./configure \
          --prefix=/usr/src/oniguruma-static \
          --disable-shared \
          --enable-static

      echo "=== Making Oniguruma"
      make -j"$(nproc)"

      echo "=== Making and installing Oniguruma"
      make install

      echo "=== Changing to directory: .."
      cd ..
    fi
    if [ ! -f "/usr/src/oniguruma-static/lib/libonig.a" ]; then
      echo "=== ERROR: Oniguruma library not found, exiting..."
      exit 1
    else
      echo "=== Oniguruma library found at /usr/src/oniguruma-static/lib/libonig.a"
      export ONIG_CFLAGS="-I/usr/src/oniguruma-static/include"
      export ONIG_LIBS="-L/usr/src/oniguruma-static/lib -l:libonig.a"
    fi
    press_enter "=== Press enter to continue ==============================================================================="

    # Check if target directory exist
    if [ ! -d "$BUILD_DIR/php-$PHP_V" ]; then
      BUILDING_NOW=1
      
      if [ ! -d "php-$PHP_V" ]; then
        echo "=== Removing existing php directory: php-$PHP_V"
        rm -rf php-$PHP_V
      fi
      echo "=== Download and unpack PHP source files from $PHP and extracting it"
      wget -nv -qO- $PHP | tar xz
      
      echo "=== Change to php directory to: php-$PHP_V"
      cd php-$PHP_V
      
      press_enter "=== Press enter to configure PHP ==============================================================================="
      
      echo "=== Configure PHP"
      ./configure --prefix=$INSTALL_DIR/php \
                  --enable-fpm \
                  --with-zlib \
                  --with-fpm-user=admin \
                  --with-fpm-group=admin \
                  --with-mysqli \
                  --with-curl \
                  --enable-mbstring \
                  --with-mysql-sock=/var/run/mysqld/mysqld.sock \
                  --without-sqlite3 \
                  --without-pdo-sqlite
      
      # Check install directory and remove if exists
      if [ -d "$INSTALL_DIR/php" ]; then
          echo "=== Removing existing php directory: $INSTALL_DIR/php"
          rm -rf $INSTALL_DIR/php
      fi
    
      press_enter "=== Press enter to compile PHP ==============================================================================="

      echo "=== Making PHP"
      make
      echo "=== Making and installing PHP"
      make install
      
      press_enter "=== Press enter to continue ==============================================================================="
    fi

    echo "=== Changing to build directory: $BUILD_DIR"
    cd $BUILD_DIR
    if [ -d "vesta-php_$VESTA_PHP_V" ]; then
      echo "=== Removing existing vesta-php directory: vesta-php_$VESTA_PHP_V"
      rm -rf vesta-php_$VESTA_PHP_V
    fi
    echo "=== Create directory: $BUILD_DIR/vesta-php_$VESTA_PHP_V"
    mkdir -p $BUILD_DIR/vesta-php_$VESTA_PHP_V
    
    echo "=== Changing to directory: $BUILD_DIR/vesta-php_$VESTA_PHP_V"
    cd $BUILD_DIR/vesta-php_$VESTA_PHP_V/
    echo "=== Creating directories: usr/local/vesta/php and DEBIAN"
    mkdir -p usr/local/vesta/php DEBIAN
    
    # Copying control, postinst and postrm files
    echo "=== Copying /root/vesta/src/deb/php/* files to $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN"
    cp -rf /root/vesta/src/deb/php/* $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN
    
    # Set version
    echo "=== Setting version: $VESTA_PHP_V in $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN/control"
    sed -i "/Version: /c\Version: $VESTA_PHP_V" $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN/control
    
    # Set permission
    echo "=== Setting permission: +x for $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN/postinst"
    chmod +x $BUILD_DIR/vesta-php_$VESTA_PHP_V/DEBIAN/postinst
    
    press_enter "=== Press enter to copy builded php ==============================================================================="

    echo "=== Changing to directory: .."
    cd ..
    
    # if [ $BUILDING_NOW -eq 1 ]; then
    echo "=== Copying $INSTALL_DIR/php/* files to $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/"
    cp -rf $INSTALL_DIR/php/* $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/
    press_enter "=== Done, press enter to copy php-fpm.conf and vesta-php binary ==============================================================================="
    # fi
    
    echo "=== Copying /root/vesta/src/deb/for-download/php/php-fpm.conf to $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/etc/php-fpm.conf"
    cp /root/vesta/src/deb/for-download/php/php-fpm.conf $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/etc/php-fpm.conf
    echo "=== Copying /root/vesta/src/deb/for-download/php/php.ini to $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/lib/php.ini"
    cp /root/vesta/src/deb/for-download/php/php.ini $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/lib/php.ini
    
    echo "=== Copying $INSTALL_DIR/php/sbin/php-fpm to $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/sbin/vesta-php"
    cp $INSTALL_DIR/php/sbin/php-fpm $BUILD_DIR/vesta-php_$VESTA_PHP_V/usr/local/vesta/php/sbin/vesta-php

    echo "=== Making deb package: vesta-php_$VESTA_PHP_V"
    make_deb_package "vesta-php" "$VESTA_PHP_V"
  fi
  if [ $add_deb_to_apt_repo -eq 1 ]; then
    echo "=== Adding deb to apt repo: vesta-php_$VESTA_PHP_V"
    add_to_repo "vesta-php" "$VESTA_PHP_V"
  fi
    
  echo "=== All done for vesta-php_$VESTA_PHP_V"
fi

#################################################################################
#
# Building vesta
#
#################################################################################

if [ "$VESTA_B" = true ]; then
  if [ $build_deb_package -eq 1 ]; then
    echo "======= Building vesta package ======="
    # Change to build directory
    cd $BUILD_DIR
    
    # Check if target directory exist
    if [ -d $BUILD_DIR/vesta_$VESTA_V ]; then
        rm -rf $BUILD_DIR/vesta_$VESTA_V
    fi
    
    # Create directory
    mkdir $BUILD_DIR/vesta_$VESTA_V
    
    # Prepare Deb Package Folder Structure
    cd vesta_$VESTA_V/
    mkdir -p usr/local/vesta DEBIAN
    
    # Copying control, postinst and postrm files
    cp -rf /root/vesta/src/deb/vesta/* $BUILD_DIR/vesta_$VESTA_V/DEBIAN
    
    # Set version
    sed -i "/Version: /c\Version: $VESTA_VER" $BUILD_DIR/vesta_$VESTA_V/DEBIAN/control
  
    # Set permission
    chmod +x $BUILD_DIR/vesta_$VESTA_V/DEBIAN/postinst
    rm $BUILD_DIR/vesta_$VESTA_V/DEBIAN/conffiles
  
    # Copying vesta source
    cp -rf /root/vesta/* $BUILD_DIR/vesta_$VESTA_V/usr/local/vesta
    
    # Set permission
    cd $BUILD_DIR/vesta_$VESTA_V/usr/local/vesta/bin
    chmod +x *
    cd $BUILD_DIR/vesta_$VESTA_V/usr/local/vesta/upd
    chmod +x *
    
    make_deb_package "vesta"
  fi
  if [ $add_deb_to_apt_repo -eq 1 ]; then
    if [ "$TARGET_DEB_NAME_MAIN" != "$TARGET_DEB_NAME" ]; then
      cd $BUILD_DIR
      if [ -f "vesta_$VESTA_V.deb" ]; then
        rm vesta_$VESTA_V.deb
      fi
      cp $BUILD_DIR_MAIN/vesta_$VESTA_V.deb $BUILD_DIR/vesta_$VESTA_V.deb
    fi
    add_to_repo "vesta"
  fi

  echo "=== All done"
fi

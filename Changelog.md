Version 0.9.9-0-14 [2025-09-08]
==================================================
* Improvement: Introducing a new command: v-change-phpmyadmin-url
* Bugfix: Restarting Nginx if fixssl.conf is applied
* Basic .mdc rules and 'example-of-linux-root-folder' for better AI understanding and faster development in Cursor

Version 0.9.9-0-13 [2025-08-15]
==================================================
* Improvement: Activating FileManager licence for all users (credits to Official VestaCP)
* Introducing a malware cleaning set of tools: v-install-wordfence-cli, v-desinfect-wordpress, v-fix-wordpress-core, v-change-database-password-for-wordpress, v-change-wordpress-admin-passwords, v-delete-inactive-wordpress-plugins-and-themes, v-delete-wordpress-uploads-php-files) (credits to isscbta)
* Improvement: Added support for PHP 8.3 and 8.4
* SRS support for Exim4 (v-add-srs-support-to-exim) (credits to HestiaCP)
* Security: Ensuring that PHP files are visible only to the account they belong to - setting chmod 600 for all .php and .env files (also added as admin cronjob - v-fix-website-permissions-for-all-websites-only-php)
* Added cronjob for disk usage snapshot (size of each folder) to see what folder is growing every day (v-df-snapshot-make, v-df-snapshot-diff [some-day-snapshot] [some-other-day-snapshot])
* Bugfix: SSL fix for Apache 2.4.65+ (fix for '421 Misdirected Request')
* Bugfix: vst-install-debian.sh: ability to install MySQL 8 on Debian 12
* Improvement: Update nginx block-firewall.conf when user blocks 80,443 ports for some IPv4 address in the Firewall section of the admin panel
* Improvement: v-install-wordpress: Support for IDN format domains
* Security: Adding ProFTPD jail rule to Fail2Ban
* Introducing: v-make-main-apache-log - making one log file for PHP requests for all websites
* Security: Introducing a new command: v-fix-php-ini-disable-functions
* Improvement: Introducing myVesta rules for SpamAssassin (enhancing spam filtering)
* Improvement: When deleting a domain, also delete the database if the domain has a database
* Bugfix: Removing temporary Docker container network interfaces from RRD
* Introducing v-run-wp-cli-myvesta that knows the correct terminal width
* Introducing a new command: v-cd-www alias for v-change-dir-www
* Introducing a new command: v-clear-fail2ban
* Introducing a new command: v-get-dns-config (to print zone file in bind9 format)
* Introducing a DISABLE_IP_CHECK as vesta.conf variable (if logged-in user is getting a new IPv4 address every minute)
* Security: Introducing a parse_object_kv_list_non_eval() function in main.sh, to avoid the evil eval command
* Security: Enhance package validation, in v-change-user-package 'eval' replaced with 'parse_object_kv_list_non_eval'
* Improvement: Replacing all WordPress scripts to use 'v-run-wp-cli' instead of 'wp'
* Improvement: v-install-wordpress: Almost always use https
* Improvement: Skip the prompt to continue during myVesta installation if the administrator has set all required variables  in the command line
* Security: Jailing v-run-wp-cli (running WP-CLI as user, added open_basedir, disabling shell_exec() and other dangerous PHP functions)
* Security: v-commander: removing the ability to set a root password
* Bugfix: DKIM record deletion command in v-delete-mail-domain-dkim script
* Adding FTP / SFTP port for Remote Backup (credits to ikheetjeff)
* Introducing a new command: v-delete-mails - delete emails older than N days (credits to isscbta)
* Introducing new commands: v-blacklist-email-domain, v-blacklist-email-account, v-whitelist-email-domain, v-whitelist-email-account (credits to isscbta)
* Bugfix: v-move-folder-and-make-symlink: use 'mv' instead of 'rsync'
* Improvement: Calculate the size of directories on /hdd too
* Bugfix: v-move-domain-and-database-to-account: Update wordfence-waf.php
* Bugfix: v-add-letsencrypt-domain: Detecting valid status on wildcard variant
* Bugfix: db.sh and v-clone-website: mysqldump --max_allowed_packet=1024M
* Bugfix: web/index.php: Prevent recreation of token by shitty browser add-ons
* Bugfix: v-restore-user: permissions fix while restoring backup
* Bugfix: Add some loops due to 403 errors during LE request in some random cases
* Improvement: v-clone-website: adding --EXCLUDE_UPLOADS parameter
* Bugfix: vst-install-debian.sh - removing phppgadmin
* Bugfix: v-update-firewall: $FIREWALL_STATEFUL conf variable (for Infomaniak VPS servers)
* Bugfix: Awstats template for all systems does not have a closed bracket in line 27 (credits to gkirde)
* Bugfix: Update v-import-cpanel-backup - removing /*!999999\- enable the sandbox mode */
* Bugfix: Small PHP syntax fixes in the admin panel
* Introducing nginx template 'wprocket-webp-express-force-https' (credits to Luka Paunovic)
* Improvement: Added functions to check if a domain or user is unsuspended in main.sh
* Introducing a new command: v-update-document-errors-files
* Improvement: new v-backup-user-now command does backup even if the system Load Average is above the limit, or the administrator configured backups to perform only at night
* Improvement: v-install-wp-cli and v-install-wp-cli-myvesta - automatically updates if wp-cli is 30 days old
* Bugfix: Check for SSL certificate existence before deleting web domain SSL in v-install-unsigned-ssl
* Improvement: v-install-wordpress: avoid changing nginx proxy template in apache-less variant
* Added to .gitignore excludes for 'data', 'conf', and 'log' folders
* And many other minor bugfixes and improvements...

Version 0.9.9-0-12 [2025-02-28]
==================================================
* SpamHaus DNSBL removed from exim4
* A lot of small bugs fixed

Version 0.9.9-0-11 [2024-05-30]
==================================================
* Introducing v-run-wp-cli command ( @isscbta )
* Introducing v-add-wordpress-admin command ( @isscbta )
* Few bugs fixed

Version 0.9.9-0-10 [2024-04-11]
==================================================
* Introducing v-edit-php-ini command ( @isscbta )
* Introducing v-edit-domain-php-ini command ( @isscbta )

Version 0.9.9-0-9 [2024-04-05]
==================================================
* Get quick info about a banned IP (Host, Banlist, Location) (many thanks to @VasilisParaschos )
* Few bugs fixed

Version 0.9.9-0-5 to 0.9.9-0-8
==================================================
* Few bugs fixed

Version 0.9.9-0-4 [2023-06-27]
==================================================
* Support for Debian 12 ( in mutual cooperation with @HestiaCP )

Version 0.9.9-0-2 [2023-06-12]
==================================================
* Hosting panel UI perfomance fix

Version 0.9.9-0 [2023-06-05]
==================================================
* Redesign of hosting panel
* Fix for WP_CACHE_KEY_SALTs in v-clone-website command
* Fix for "Helo name contains a ip address" in Exim4
* Fix for Exim4 for punycode domains (in collaboration with @HestiaCP )

Version 0.9.8-26-62 [2023-04-05]
==================================================
* Fix for LetsEncrypt Asynchronous Order Finalization (in collaboration with @HestiaCP )

Version 0.9.8-26-61 [2023-04-04]
==================================================
* Many bugfixes
* Hotfix for LetsEncrypt to prevent Apache falling 

Version 0.9.8-26-60 [2023-02-12]
==================================================
* New script: v-commander (useful for maintaining the server)
* New script: v-activate-rocket-nginx (serve WP-Rocket cache directly from nginx)
* New script: v-update-myvesta (get the very latest build of myVesta)
* v-clone-website: By default cloning to database: user_domain_com (instead of cloning to database: user_old_db_migrated)
* Many minor bugfixes

Version 0.9.8-26-59 [2023-02-01]
==================================================
* Support for PHP 8.2
* New script: v-move-folder-and-make-symlink
* New script: v-lock-wordpress (to prevent PHP malware) and v-unlock-wordpress
* v-install-wordpress: Installing WordPress to user_domain_com database instead of installing to user_wp database
* Many minor bugfixes

Version 0.9.8-26-58 [2022-07-12]
==================================================
* [Security] hash_equals() in /reset/mail/ (credits to @divinity76 )
* Avoid out-of-memory while downloading large log files from panel (credits to @divinity76 )
* Fix for an boring PHP Notice in vesta-php

Version 0.9.8-26-57 [2022-07-06]
==================================================
* Fix for GMail SMTP timeouts on Debian11
* [Security] Fix for Local Sed Injection Vulnerability ( credits to @cleemy-desu-wayo )

Version 0.9.8-26-56 [2022-05-28]
==================================================
* Adding Barracuda RBL to SpamAssassin
* Fixing insane HTML form bug in List backup items page
* Script for easy adding second IP address for SMTP authenticated users only (v-make-separated-ip-for-email)

Version 0.9.8-26-55 [2022-04-26]
==================================================
* Support for MySQL 8
* [Security] Preventing brute-force resetting password  (thanks to HestiaCP @hestiacp for fix)
* Many minor bugfixes

Version 0.9.8-26-54 [2021-12-17]
==================================================
* Checking if FreshClam is started after installation

Version 0.9.8-26-53 [2021-12-12]
==================================================
* Support for PHP 8.1
* Function to ensure that pool.d folders are not empty

Version 0.9.8-26-52 [2021-11-23]
==================================================
* Fix for not to match wildcard "*domains" and "databases*" while restoring
* Added memcached to v-list-sys-services

Version 0.9.8-26-51 [2021-11-14]
==================================================
* Many fixes for "List services" page (v-list-sys-services function)

Version 0.9.8-26-50 [2021-11-07]
==================================================
* Many small bugfixes and CSRF fixes

Version 0.9.8-26-49 [2021-07-17]
==================================================
* Support for Debian 11

Version 0.9.8-26-48 [2021-07-11]
==================================================
* Fixed two bugs in LetsEncrypt generating process

Version 0.9.8-26-47 [2021-05-30]
==================================================
* Enabling TLS for ProFTPD FTPS
* More logical "Restore backup" template

Version 0.9.8-26-46 [2021-04-17]
==================================================
* [Feature] Updating CloudFlare IP addresses

Version 0.9.8-26-45 [2021-04-13]
==================================================
* [Feature] Logging whole LetsEncrypt process to /usr/local/vesta/log/letsencrypt.log and /usr/local/vesta/log/letsencrypt_cron.log
* [Feature] Warn admin once (by sending email) if LetsEncrypt renewing failed for server hostname
* [Bugfix] Correct truncating of CA LetsEncrypt certificate (thanks to HestiaCP @hestiacp for fix)

Version 0.9.8-26-44 [2021-04-04]
==================================================
* [Security] Preventing denial-of-service in openssl library in vesta-nginx service (CVE-2021-3449)
* [Security] Preventing admin to install non-vesta packages from vesta admin panel user interface (Credits to: Numan Türle @numanturle)
* [Bugfix] Preventing multiple execution of v-backup-users
* [UserInterface] CSS fix for Apache status table (Credits to: Milos Spasic)

Version 0.9.8-26-43 [2021-03-15]
==================================================
* [Security] fix for: CSRF remote code execution in UploadHandler.php - CVE-2021-28379 (Credits to: Fady Osman @fady_othman)
* [Security] fix for: Local privilege escalation from user account to admin account via v-add-web-domain (Credits to: Two independent security researchers, Marti Guasch Jiménez and Francisco Andreu Sanz, working with the SSD Secure Disclosure program) (and also thanks to HestiaCP @hestiacp for fix)
* [Security] fix for: Local privilege escalation in v-generate-ssl-cert (potential user to admin or root escalation) (Credits to: Numan Türle @numanturle, thanks to HestiaCP @hestiacp for fix)
* [Security] fix for: Local privilege escalation in /web/api/ via v-make-tmp-file (probably admin to root escalation) (Credits to: Numan Türle @numanturle, thanks to HestiaCP @hestiacp for fix)
* [Security] fix for: Cross site scripting in /web/add/ip/ (admin to other admin XSS escalation) (Credits to: Numan Türle @numanturle, thanks to HestiaCP @hestiacp for fix)
* [Security] fix for: Admin to root escalation in v-activate-vesta-license (Credits to: Numan Türle @numanturle)
* [Security] Ensure HTML will not be displayed in list log page (Credits to: Kristan Kenney @kristankenney, thanks to HestiaCP @hestiacp for fix)

Version 0.9.8-26-42 [2021-02-26]
==================================================
* [Feature] Support for PHP 8.0, see: https://forum.myvestacp.com/viewtopic.php?f=18&t=52
* [Bugfix] Making sure Apache is in mpm_event mode

Version 0.9.8-26-41 [2021-02-11]
==================================================
* Few bugfixes

Version 0.9.8-26-40 [2021-02-08]
==================================================
* Few bugfixes

Version 0.9.8-26-39 [2020-12-12]
==================================================
* [Security] Fixing useless issue with tokens in "download backup" and "loginas" functions (thanks to HestiaCP for fixes)
* [Security] Fixing XSS in /list/rrd/?period= value

Version 0.9.8-26-38 [2020-12-05]
==================================================
* [Security] Fixing Apache status public access (thanks to HestiaCP for letting us know)

Version 0.9.8-26-37 [2020-10-26]
==================================================
* [Bugfix] Fixing LetsEncrypt deprecated GET method for ACME v2 (thanks to @moucho)
* [Bugfix] Fixing Roundcube to send via authenticated SMTP user instead via php

Version 0.9.8-26-36 [2020-09-10]
==================================================
* [Bugfix] Checking necessary available disk space before doing backup
* [Security] Disabling login with 'root'

Version 0.9.8-26-35 [2020-08-23]
==================================================
* [Feature] Limiting max recipients per email to 15, in order to prevent mass spamming
* [Bugfix] While restoring backup, only exclude logs folder from root, not in public_html

Version 0.9.8-26-34 [2020-08-19]
==================================================
* [Bugfix] Split long DNS TXT entries into 255 chunks

Version 0.9.8-26-33 [2020-08-16]
==================================================
* [Feature] Ability to set some domain to send emails from another IP (command: v-make-separated-ip-for-email-domain)

Version 0.9.8-26-32 [2020-08-02]
==================================================
* [Feature] v-replace-in-file command introduced
* [Security] Making sure new myVesta commands can be called only by root

Version 0.9.8-26-31 [2020-07-30]
==================================================
* [Feature] v-import-cpanel-backup command moved to vesta-bin folder (becoming standard myVesta command)
* Starting to log auto-update output

Version 0.9.8-26-30 [2020-07-26]
==================================================
* New ASCII logo in installer
* Deleted favicon when user don't know secret-url of hosting panel
* [bugfix] Minor bug fixed in v-make-separated-ip-for-email
* [bugfix] Minor fix of URL for templates in v-update-dns-templates
* [bugfix] Minor fixes in installer

Version 0.9.8-26-29 [2020-07-21]
==================================================
* [Feature] v-clone-website command moved to vesta-bin folder (becoming standard myVesta command)
* [Feature] v-migrate-site-to-https command moved to vesta-bin folder (becoming standard myVesta command)
* [Bugfix] Fix for ClamAV socket
* Changing Vesta to myVesta in title of hosting panel pages

Version 0.9.8-26-28 [2020-07-15]
==================================================
* [Feature] v-install-wordpress command introduced
* [Feature] v-move-domain-and-database-to-account command introduced
* [Feature] v-make-separated-ip-for-email command introduced
* [Bugfix] Fix for LetsEncrypt issuing in apache-less variant (nginx + php-fpm variant)
* [Bugfix] Fix for configuring phpMyAdmin DB in apache-less variant (nginx + php-fpm variant)

Version 0.9.8-26-27 [2020-07-05]
==================================================
* [Feature] Admins now see changelog when they open myVesta panel after myVesta get updated (changelog will dissapear on next refresh)
* [Bugfix] Better control of opened SMTP concurrent connections (preventing denial-of-service of SMTP) on fresh installed servers - https://github.com/myvesta/vesta/commit/c57b15b5daca2a0ea88ee6a89a2ff5a4ef47d2a3
* Second tuning of php-fpm pool.d config files (perfomances and limits)

Version 0.9.8-26-26 [2020-06-27]
==================================================
* [Feature] Self-signed SSL will be automaticaly added when you add new domain (CloudFlare is fine with that, you don't need LetsEncrypt anymore if you use CloudFlare as reverse-proxy(CDN+Firewall), just set "Full" in SSL section on CloudFlare)
* [Feature] Script for adding self-signed SSL to desired domain [v-install-unsigned-ssl]
* From now, on fresh installed server, default backup cron goes at Saturday at 01 AM (instead of everyday at 05 AM)
* New favicon for hosting panel

Version 0.9.8-26-25 [2020-06-23]
==================================================
* [Security] Fixing unnecessary slash in nginx configs for phpmyadmin and roundcube (Credits to Bernardo Berg @bberg1984 for finding this issue!)
* [Security] Adding escapeshellarg on few more places in php code (Credits to Talha Günay and @Lupul for finding these places)

Version 0.9.8-26-24 [2020-06-22]
==================================================
* [Bugfix] nginx + php-fpm installer variant now finally works

Version 0.9.8-26-23 [2020-06-14]
==================================================
* Adding label that LetsEncrypt can be added when you Edit domain

Version 0.9.8-26-22 [2020-06-13]
==================================================
* [Bugfix] Checking (in order to delete) php7.4 pool config file while deleting domain

Version 0.9.8-26-21 [2020-06-13]
==================================================
* [Feature] Blocking executable files inside archives in received emails (ClamAV)
* [Bugfix] Removing ability to schedule LetsEncrypt issuing while adding new domain (because it can fall in infinite loop whole day)
* [Bugfix] Force acme-challenge to use Apache if myVesta is behind main nginx
* [Bugfix] Adding http2 support to nginx caching.tpl
* [Bugfix] Script that removes depricated 'ssl on;' in nginx templates
* [Security] Ensure UPDATE_SSL_SCRIPT is not set in some config files

Version 0.9.8-26-20 [2020-06-01]
==================================================
* [Bugfix] Script that will ensure that Apache2 will always stay in mpm_event mode
* [Bugfix] Ensure config files will not be overwritten while updating vesta-nginx package
* [Bugfix] Fixing URL in v-update-web-templates script
* [Feature] Additional rates for nginx anti-denial-of-service templates

Version 0.9.8-26-19 [2020-05-15]
==================================================
* [Bugfix] Do not match subdomains while restoring domain [v-restore-user]

Version 0.9.8-26-18 [2020-05-15]
==================================================
* [Bugfix] Fixing NS parameters in v-add-dns-on-web-alias

Version 0.9.8-26-17 [2020-05-15]
==================================================
* [Bugfix] Reverting default clamav socket path 
* [Bugfix] Put mail_max_userip_connections = 50 in dovecot

Version 0.9.8-26-16 [2020-05-15]
==================================================
* [Bugfix] Allow quick restarting of nginx if acme-challenge should be added many times
* [Bugfix] Enabling email notification to fresh installed servers about backup success status
* [Bugfix] Timeout 10 sec for apache2 status

Version 0.9.8-26-15 [2020-05-09]
==================================================
* [Feature] nginx templates that can prevent denial-of-service on your server
* First tuning php-fpm pool.d config files (perfomances and limits)
* New logo

Version 0.9.8-26-14 [2020-05-08]
==================================================
* v-clone-website script switched to parameters
* Display new version in console while updating myVesta

Version 0.9.8-26-13 [2020-05-07]
==================================================
* [Feature] Put build date and version in right-bottom corner of control panel

Version 0.9.8-26-12 [2020-05-07]
==================================================
* [Feature] Put build date and version while compiling myVesta
* [Feature] Office365 DNS template
* [Feature] Yandex DNS template
* ProFTPD MaxIstances = 100 for fresh installed servers

Version 0.9.8-26-11 [2020-05-01]
==================================================
* [Feature] Skipping LE renewing after 7 failed attempts
* [Bugfix] Keep conf files during auto-update
* [Bugfix] Do not restart apache while preparing letsencrypt acme challenge
* [Bugfix] Set ALLOW_BACKUP_ANYTIME='yes' for fresh installed servers

Version 0.9.8-26-10 [2020-04-11]
==================================================
* [Feature] Creating v-normalize-restored-user script (normalize NS1, NS2 and IP of account that is backuped on other server and restored on this server)
* Tweak for hostname FPM conf
* [Security] Forbid changing root password (Credits to Alexandre ZANNI, Orange Cyberdefense, https://cyberdefense.orange.com)
* [Security] Importing system enviroment in v-change-user-password (Credits to Alexandre ZANNI, Orange Cyberdefense, https://cyberdefense.orange.com)

Version 0.9.8-26-9 [2020-03-23]
==================================================
* [Security] Preventing manipulation with $SERVER['HTTP_HOST'] (Credits to @mdisec - Managing Partner of PRODAFT / INVICTUS A.Ş. Master ninja at pentest.blog)

Version 0.9.8-26-8 [2020-03-23]
==================================================
* [Security] Temporary fix for parsing backup conf (Credits to @dreiggy - https://pentest.blog/vesta-control-panel-second-order-remote-code-execution-0day-step-by-step-analysis/)

Version 0.9.8-26-7 [2020-03-18]
==================================================
* [Bugfix] Fix that avoid LetsEncrypt domain validation timeout
* [Bugfix] Set timeout in v-list-sys-web-status script

Version 0.9.8-26-6 [2020-02-21]
==================================================
* [Bugfix] mail-wrapper.php from now works
* [Feature] Introducing NOTIFY_ADMIN_FULL_BACKUP, email notification about backup success status
* [Feature] Introducing KEEP_N_FTP_BACKUPS, ability to limit number of remote FTP backups
* [Feature] Introducing force-https-webmail-phpmyadmin nginx template
* [Feature] Trigger for /root/update_firewall_custom.sh

Version 0.9.8-26-5 [2020-02-10]
==================================================
* [Security] sudoers fix for Debian10
* [Feature] [Script that will migrate your site from http to https, replacing http to https URLs in database](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/v-migrate-site-to-https)
* [Feature] [Cloning script that will copy the whole site from one domain to another (sub)domain](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/v-clone-website)
* [Feature] [Script that will install multiple PHP versions on your server](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/multi-php-install.sh)
* [Bugfix] Roundcube force https
* [Bugfix] Exim compatibility with Loopia for Debian10

Version 0.9.8-26-4 [2020-01-07]
==================================================
* [Feature] Allow whitelisting specific IP for /api/
* [Feature] Allow whitelisting specific IP to avoid secret_url
* [Feature] Allow Softaculous in secure_login gateway
* [Bugfix] apparmor install fix again
* [Bugfix] Turning off MariaDB SQL strict mode

Version 0.9.8-26-3 [2019-11-26]
==================================================
* [Bugfix] Better check if session cron already added

Version 0.9.8-26-2 [2019-11-15]
==================================================
* [Feature] Support for sub-sub-sub-sub versions :))
* [Bugfix] Support for longer username of email accounts
* [Bugfix] apparmor install fix
* [Bugfix] Trying to fix ClamAV broken socket
* Moving to myvestacp.com

Version 0.9.8-26 [2019-09-28]
==================================================
* [Bugfix] Let's Encrypt HTTP/2 support (by @serghey-rodin)
* [Bugfix] Fixing broken autoreply output
* [Feature] Multi-PHP support for PHP 7.4
* [Feature] Multi-PHP installer for Debian 8
* [Bugfix] Cron for removing old PHP sessions files
* [Bugfix] New CloudFlare IPs
* [Security] MySQL port blocked by default from outside
* [Feature] Warning when server hostname is not pointing to server IP
* [Feature] max_length_of_MySQL_username=80

Older versions
==================================================
* Support for Debian 10 (previous Debian releases are also supported, but Debian 10 is recommended)
* [Support for multi-PHP versions](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/multi-php-install.sh)
* You can limit the maximum number of sent emails (per hour) [per mail account](https://github.com/myvesta/vesta/blob/master/install/debian/10/exim/exim4.conf.template#L105-L106) and [per hosting account](https://github.com/myvesta/vesta/blob/master/install/debian/10/exim/exim4.conf.template#L65-L66), preventing hijacking of email accounts and preventing PHP malware scripts to send spam.
* You can see [what PHP scripts are sending emails](https://github.com/myvesta/vesta/blob/master/install/debian/10/php/php7.3-dedi.patch#L50), when and to whom
* You can completely "lock" myVesta so it can be accessed only via **secret URL**, for example https://serverhost:8083/?MY-SECRET-URL
    + Literally no PHP scripts will be alive on your hosting panel (won't be able to get executed), unless you access the hosting panel with secret URL parameter. Thus, when it happens that, let's say, some zero-day exploit pops up - attackers won't be able to access it without knowing your secret URL - PHP scripts from myVesta
* We [disabled dangerous PHP functions](https://github.com/myvesta/vesta/blob/master/install/debian/10/php/php7.3-dedi.patch#L9) in php.ini, so even if, for example, your customer's CMS gets compromised, hacker will not be able to execute shell scripts from within PHP.
* Apache is fully switched to mpm_event mode, while PHP is running in PHP-FPM mode, which is the most stable PHP-stack solution
    + OPCache is turned on by default
* Auto-generating LetsEncrypt SSL for server hostname (signed SSL for Vesta 8083 port, for dovecot (IMAP & POP3) and for Exim (SMTP))
* You can change Vesta port during installation or later using one command line: **v-change-vesta-port [number]**
* Backup will run with lowest priority (to avoid load on server), and can be configured to run only by night (and to stop on the morning and continue next night)
* You can compile Vesta binaries by yourself
* [Script that will convert Vesta to myVesta](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/convert-vesta-to-myvesta.sh)
* [Wordpress installer in one second](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/create_wp_https)
* [Script for importing cPanel backups to Vesta](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/cpanel-import.sh)
* [Official Vesta Softaculous installer](https://github.com/myvesta/vesta/blob/master/src/deb/for-download/tools/install-softaculous.sh)

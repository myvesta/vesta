#
# this file directory: /usr/local/vesta/data/templates/web/nginx/php-fpm/
#
server {
    listen      %ip%:%web_port% default_server;
    server_name %domain_idn% %alias_idn%;
	# redirect http > httpS (www cut)
    return 301 https://%domain_idn%$request_uri;
    root        %docroot%;
    index       index.php index.html;
    access_log  /var/log/nginx/domains/%domain%.log combined;
    access_log  /var/log/nginx/domains/%domain%.bytes bytes;
    error_log   /var/log/nginx/domains/%domain%.error.log error;

    location / {

    # запрещаем всем доступ
    # access is denied to everyone
        deny  all;
    # не засоряем лог отказом в доступе
    # we do not clog the blog with access denial
        access_log off;
        log_not_found off;
    }

    error_page  403 /error/404.html;
    error_page  404 /error/404.html;
    error_page  500 502 503 504 /error/50x.html;

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }
	
	location /vstats/ {
        alias   %home%/%user%/web/%domain%/stats/;
        include %home%/%user%/conf/web/%domain%.auth*;
    }

    include     /etc/nginx/conf.d/phpmyadmin.inc*;
    include     /etc/nginx/conf.d/phppgadmin.inc*;
    include     /etc/nginx/conf.d/webmail.inc*;

    include     %home%/%user%/conf/web/nginx.%domain%.conf*;
    
    gzip on;
    gzip_static on;
    gzip_proxied any;
    gzip_min_length 512;
    gzip_buffers 16 8k;
    gzip_comp_level 3;
    gzip_vary on;
    gzip_types
        application/atom+xml
        application/javascript
        application/json
        application/ld+json
        application/manifest+json
        application/rss+xml
        application/vnd.geo+json
        application/vnd.ms-fontobject
        application/x-font-ttf
        application/x-web-app-manifest+json
        application/xhtml+xml
        application/xml
        font/opentype
        image/bmp
        image/svg+xml
        image/x-icon
        text/cache-manifest
        text/css
        text/plain
        text/vcard
        text/vnd.rim.location.xloc
        text/vtt
        text/x-component
        text/x-cross-domain-policy;
}

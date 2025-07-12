server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    location / {
        rewrite ^(.*) https://$host$1 permanent;
    }
include %home%/%user%/conf/web/*nginx.%domain_idn%.conf_letsencrypt;
}

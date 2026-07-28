server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;

    access_log off;
    error_log  /dev/null crit;

    return 444;
}

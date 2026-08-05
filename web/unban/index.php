<?php

/*

This script is used to unban an IP address from the firewall.

To activate this script, run the following command in the terminal logged in as root:
echo "<?php \$secret_url='YOUR_SECRET_URL';" > /usr/local/vesta/web/unban/secret.php

Then your customers can unban their own IP address by opening the following URL:
https://your-vesta-server.com:8083/unban/?YOUR_SECRET_URL

*/

$secret_url='';
$secret_url_valid=false;

if (file_exists('/usr/local/vesta/web/unban/secret.php')) {
    require_once('/usr/local/vesta/web/unban/secret.php'); // get secret url
    if (isset($_GET[$secret_url])) {                         // check if user opened secret url
         $secret_url_valid=true;
    }
} else {
    die('Secret URL file not found');
}

if ($secret_url_valid==false) {
    die('Secret URL is not valid');
}

$ip=$_SERVER['REMOTE_ADDR'];
$ip_original=$ip;
$ip=escapeshellarg($ip);

$unban_success=false;

$chain_array=array('WEB', 'SSH', 'FTP', 'MAIL');
foreach ($chain_array as $chain) {
    $run="/usr/bin/sudo /usr/local/vesta/bin/v-delete-firewall-ban ".$ip." '".$chain."'";
    exec ($run, $output, $return_var);
    // echo $return_var.'<br>';
    if (intval($return_var)==0) $unban_success=true;
    unset($output);
}

if ($unban_success) {
    echo 'IP address <b>'.$ip_original.'</b> is unbanned successfully.';
} else {
    echo 'IP address <b>'.$ip_original.'</b> is not found in banlist.';
}
exit;

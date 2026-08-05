<?php

$secure_gate_check=true;

if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web/inc/mail-wrapper.php') $secure_gate_check=false; // it can be executed only from cli

if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web/reset/mail/index.php') $secure_gate_check=false; // it's accessible only from localhost
if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web//reset/mail/index.php') $secure_gate_check=false;

if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web/api/index.php') $secure_gate_check=false; // api has its own security check
if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web//api/index.php') $secure_gate_check=false;

if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web/reset/mail/set-ar.php') $secure_gate_check=false; // commercial addon for changing auto-reply from Roundcube, not included in this fork, also accessible only from localhost
if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web//reset/mail/set-ar.php') $secure_gate_check=false;
if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web/reset/mail/get-ar.php') $secure_gate_check=false;
if ($_SERVER['SCRIPT_FILENAME']=='/usr/local/vesta/web//reset/mail/get-ar.php') $secure_gate_check=false;
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 28)=='/usr/local/vesta/web/custom/') $secure_gate_check=false; // custom scripts like git webhooks
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 29)=='/usr/local/vesta/web//custom/') $secure_gate_check=false;

if (substr($_SERVER['SCRIPT_FILENAME'], 0, 27)=='/usr/local/vesta/web/unban/') $secure_gate_check=false; // fail2ban unban script
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 28)=='/usr/local/vesta/web//unban/') $secure_gate_check=false;

if (substr($_SERVER['SCRIPT_FILENAME'], 0, 21)=='/usr/local/vesta/bin/') $secure_gate_check=false; // allow executing v-* PHP scripts from bash
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 29)=='/usr/local/vesta/softaculous/') $secure_gate_check=false; // allow softaculous
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 33)=='/usr/local/vesta/web/softaculous/') $secure_gate_check=false; // allow softaculous
if (substr($_SERVER['SCRIPT_FILENAME'], 0, 34)=='/usr/local/vesta/web//softaculous/') $secure_gate_check=false; // allow softaculous

$check_file="/usr/local/vesta/conf_web/allow_ip_for_secret_url.conf";
if (file_exists($check_file)) {
    $file_content=file($check_file);
    if (is_array($file_content)) {
        foreach ($file_content as $line) {
            if (trim($line) == $_SERVER['REMOTE_ADDR']) {$secure_gate_check=false; break;}
        }
    }
}

if ($secure_gate_check==true) {
    if (!isset($login_url_loaded)) {
        $login_url_loaded=1;
        if (file_exists('/usr/local/vesta/web/inc/login_url.php')) {
            require_once('/usr/local/vesta/web/inc/login_url.php'); // get secret url
            if (isset($_GET[$login_url])) {                         // check if user opened secret url
                $Domain=$_SERVER['HTTP_HOST'];
                $Port = strpos($Domain, ':');
                if ($Port !== false)  $Domain = substr($Domain, 0, $Port);
                setcookie($login_url, '1', time() + 31536000, '/', $Domain, true); // set secret cookie
                header ("Location: /login/");
                exit;
            }
            if (!isset($_COOKIE[$login_url])) exit; // die if secret cookie is not set
        }
    }
}

function prevent_post_csrf ($hard_check=false) {
    if (file_exists('/usr/local/vesta/conf_web/dont_check_csrf')) return; 
    if ($_SERVER['REQUEST_METHOD']=='POST') {
        if ($hard_check == false) {
            if (isset($_SERVER['HTTP_HOST']) == false) return;
            if (isset($_SERVER['SERVER_PORT']) == false) return;
            if (isset($_SERVER['HTTP_ORIGIN']) == false) return;
        } else {
            if (isset($_SERVER['HTTP_HOST']) == false) $_SERVER['HTTP_HOST'] = '';
            if (isset($_SERVER['SERVER_PORT']) == false) $_SERVER['SERVER_PORT'] = '';
            if (isset($_SERVER['HTTP_ORIGIN']) == false) $_SERVER['HTTP_ORIGIN'] = '';
        }
        $_SERVER['HTTP_HOST'] = strtolower($_SERVER['HTTP_HOST']);
        $_SERVER['HTTP_ORIGIN'] = strtolower($_SERVER['HTTP_ORIGIN']);
        if ($hard_check == false) {
            if (substr($_SERVER['HTTP_ORIGIN'], 0, 8) != "file:///" && substr($_SERVER['HTTP_ORIGIN'], 0, 7) != "http://" && substr($_SERVER['HTTP_ORIGIN'], 0, 8) != "https://") return;
        }
        $host_arr = explode(":", $_SERVER['HTTP_HOST']);
        $hostname = $host_arr[0];
        $port = $_SERVER['SERVER_PORT'];
        $expected_http_origin = "https://".$hostname.":".$port;
        $level = 1;
        if ($hard_check == true) $level = 2;
        if ($_SERVER['HTTP_ORIGIN'] != $expected_http_origin) {
            die ("CSRF detected (".$level.").<br />Your browser sent HTTP_ORIGIN with value: <b>".$_SERVER['HTTP_ORIGIN']."</b><br />myVesta expected HTTP_ORIGIN with value: <b>".$expected_http_origin."</b><br />Probably some browser extension is blocking it... disable all browser extensions and try again (or try to login with other browser).<br />If you are system administrator of this server, you can disable CSRF check by doing (as root, in SSH): <b>mkdir -p /usr/local/vesta/conf_web && touch /usr/local/vesta/conf_web/dont_check_csrf</b><br >(but we don't recommend it)<br />If you are not system administrator of this server and you can't access the hosting panel even you disabled all browser extensions, please copy-paste this message to the system administrator of this server.<br />Once again, before you disable CSRF check, try to disable all browser extensions or try to login with other browser.");
        }
    }
}

function prevent_get_csrf () {
    global $login_url;
    if (file_exists('/usr/local/vesta/conf_web/dont_check_csrf')) return;
    if ($_SERVER['REQUEST_METHOD'] == "GET") {
        if (isset($_GET[$login_url])) return;
        if ($_SERVER['REQUEST_URI']=="" || $_SERVER['REQUEST_URI']=="/" || $_SERVER['REQUEST_URI']=="/login/" || $_SERVER['REQUEST_URI']=="/list/user/" || $_SERVER['REQUEST_URI']=="/list/web/") return;
        if ($_SERVER['DOCUMENT_URI']=="/reset/index.php") return;
    }
    if (isset($_SERVER['HTTP_HOST']) == false) return;
    if (isset($_SERVER['SERVER_PORT']) == false) return;
    if (isset($_SERVER['HTTP_REFERER']) == false) return;
    $_SERVER['HTTP_HOST'] = strtolower($_SERVER['HTTP_HOST']);
    if (substr($_SERVER['HTTP_REFERER'], 0, 8) != "file:///" && substr($_SERVER['HTTP_REFERER'], 0, 7) != "http://" && substr($_SERVER['HTTP_REFERER'], 0, 8) != "https://") return;
    $host_arr = explode(":", $_SERVER['HTTP_HOST']);
    $hostname = $host_arr[0];
    $port = $_SERVER['SERVER_PORT'];
    $expected_http_referer = "https://".$hostname.":".$port;
    $expected_http_referer_length = strlen($expected_http_referer);
    if (substr($_SERVER['HTTP_REFERER'], 0, $expected_http_referer_length) != $expected_http_referer) {
        die ("You clicked on someone's link from other site.<br />This is just a protection layer to prevent potentially dangerous clicks, so if it was your link (or you got the link from the trusted source) - then you can <a style=\"color: green\" href=\"".$expected_http_referer.$_SERVER['REQUEST_URI']."\"><b>proceed safely to your hosting panel</b></a>.<br /><br />Technical details:<br />Your browser sent HTTP_REFERER with value: <b>".$_SERVER['HTTP_REFERER']."</b><br />myVesta expected HTTP_REFERER to begin with value: <b>".$expected_http_referer."</b><br />If you got this error during casual work in your hosting panel, probably some browser extension is blocking HTTP_REFERER... disable all browser extensions and try again (or try to login with other browser).<br />If you are system administrator of this server, you can disable CSRF check by doing (as root, in SSH): <b>mkdir -p /usr/local/vesta/conf_web && touch /usr/local/vesta/conf_web/dont_check_csrf</b><br >(but we don't recommend it)<br />If you are not system administrator of this server and you can't access the hosting panel even you clicked \"<b>proceed safely to your hosting panel</b>\" and disabled all browser extensions or changed the browser, please copy-paste this message to the system administrator of this server.<br />Once again, before you disable CSRF check, try to click \"<b>proceed safely to your hosting panel</b>\", and if that does not help then try to disable all browser extensions or try to login with other browser.");
    }
}

// Preventing all CSRFs
if ($secure_gate_check == true) {
    prevent_post_csrf();
    prevent_get_csrf();
}

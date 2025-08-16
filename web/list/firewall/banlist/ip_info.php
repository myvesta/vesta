<?php
error_reporting(NULL);
session_start();

include($_SERVER['DOCUMENT_ROOT'].'/inc/main.php');

if (!function_exists('str_contains')) {
    function str_contains($haystack, $needle)
    {
        return $needle !== '' && mb_strpos($haystack, $needle) !== false;
    }
}

// cidrMatch() based on https://stackoverflow.com/a/14535823
function cidrMatch($ip, $range)
{
    if (!filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) return false;
    list($subnet, $bits) = explode('/', $range);
    $ip = substr(ipToBinary($ip), 0, $bits);
    $subnet = substr(ipToBinary($subnet), 0, $bits);
    return ($ip == $subnet);
}

// ipToBinary based on https://stackoverflow.com/a/14535823
function ipToBinary($ip)
{
    $ipbin = '';
    $ips = explode(".", $ip);
    foreach ($ips as $iptmp) {
        $ipbin .= sprintf("%08b", $iptmp);
    }
    return $ipbin;
}

function fetchURL($url, &$info = [])
{
    $curl_handle = curl_init();
    curl_setopt($curl_handle, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($curl_handle, CURLOPT_ENCODING, 'gzip, deflate');
    curl_setopt($curl_handle, CURLOPT_URL, $url);
    curl_setopt($curl_handle, CURLOPT_CONNECTTIMEOUT, 10);
    curl_setopt($curl_handle, CURLOPT_RETURNTRANSFER, 1);
    $data = curl_exec($curl_handle);
    $info = curl_getinfo($curl_handle);
    curl_close($curl_handle);
    return $data;
}

function parseCacheEntries($strEntries)
{
    $parsed = [];
    $entries = explode("\n", $strEntries);
    if ($entries) {
        foreach ($entries as $entry) {
            list($entry,) = explode("#", $entry);
            list($entry,) = explode(";", $entry);
            $entry = trim($entry);
            if (!empty($entry)) $parsed[] = $entry;
        }
    }
    return $parsed;
}

function checkIP($ip)
{
    $check_results = [];
    $lists = [
        'BDEALL' => 'http://lists.blocklist.de/lists/all.txt',
        'BFB' => 'http://danger.rulez.sk/projects/bruteforceblocker/blist.php',
        'CIARMY' => 'http://www.ciarmy.com/list/ci-badguys.txt',
        'GREENSNOW' => 'https://blocklist.greensnow.co/greensnow.txt',
        'SPAMDROP' => 'https://www.spamhaus.org/drop/drop.txt',
        'SPAMEDROP' => 'https://www.spamhaus.org/drop/edrop.txt',
        'TOR' => 'https://check.torproject.org/cgi-bin/TorBulkExitList.py',
    ];
    $today = date('Y-m-d');

    foreach ($lists as $code => $url) {
        $cache_tag = 'ip-blacklist-' . $code . '-cache';

        // init cache
        if (!isset($_SESSION[$cache_tag])) $_SESSION[$cache_tag] = ['updated' => '', 'items' => [], 'http_code' => ''];

        // invalidate cache if clear_cache parameter is 1
        if (!empty($_REQUEST['clear_cache']) && $_REQUEST['clear_cache'] == 1) $_SESSION[$cache_tag]['updated'] = '2000-01-01';

        // if cache is not updated, fetch new data and save to cache
        if (strtotime($today) > strtotime($_SESSION[$cache_tag]['updated'])) {
            $new_cache_data = fetchURL($url, $url_result);
            if ($url_result['http_code'] == '200') $new_cache_items = parseCacheEntries($new_cache_data);
            $_SESSION[$cache_tag] = ['updated' => $today, 'items' => $new_cache_items, 'http_code' => $url_result['http_code']];
        }

        // check ip 
        $matched_ips = array_filter($_SESSION[$cache_tag]['items'], function ($item) use ($ip) {
            if (str_contains($item, '/')) return cidrMatch($ip, $item);
            if ($ip == $item) return true;
            return false;
        });

        $check_results[$code]['found'] = count($matched_ips) > 0 ? true : false;
        $check_results[$code]['updated'] = $_SESSION[$cache_tag]['updated'];
        $check_results[$code]['http_code'] = $_SESSION[$cache_tag]['http_code'];
    }

    return $check_results;
}

// Check token
if ((!isset($_REQUEST['token'])) || ($_SESSION['token'] != $_REQUEST['token'])) {
    die("Wrong token");
}

$ip = $_REQUEST['ip'];

// Validate IP format
if (filter_var($ip, FILTER_VALIDATE_IP) === false) {
    die('<strong>GENERAL ERROR</strong><br>BAD_IP_FORMAT');
}

// Query host
$host = gethostbyaddr($ip);

// Query blocklists
$result_blocklists = '';
$ip_check = checkIP($ip);
if ($ip_check) {
    foreach ($ip_check as $list_code => $list_results) {
        $result_blocklists .= '<div title="'.$list_results['updated'].' / '.$list_results['http_code'].'">';
        $result_blocklists .= $list_results['found'] ? '<i class="fas fa-fw fa-exclamation-triangle"></i>' : '<i class="fas fa-fw fa-check-circle"></i>';
        $result_blocklists .= '&nbsp;<span>'.$list_code.'</span>&nbsp;';
        $result_blocklists .= $list_results['http_code'] == '200' ? '' : '<i class="fas fa-fw fa-exclamation-circle"></i>';
        $result_blocklists .= '</div>';
    }
}

// Query location
$url = 'https://api.db-ip.com/v2/free/'.$ip;
$result = fetchURL($url);
$result_array = json_decode($result, true);
if (!is_array($result_array)) {
    die('<strong>GENERAL ERROR</strong><br>BAD_JSON');
}
if (!empty($result_array['errorCode'])) {
    die('<strong>GENERAL ERROR</strong><br>'.$result_array['errorCode']);
}

// Output
echo "
<dl>
    <dt>".__('Host')."</dt>
    <dd>".$host."</dd>
    <dt>".__('Banlist')."</dt>
    <dd>".$result_blocklists."</dd>
    <dt>".__('Continent')."</dt>
    <dd>".$result_array['continentName']." [".$result_array['continentCode']."]</dd>
    <dt>".__('Country')."</dt>
    <dd>".$result_array['countryName']." [".$result_array['countryCode']."]</dd>
    <dt>".__('State / Province')."</dt>
    <dd>".$result_array['stateProv']." [".$result_array['stateProvCode']."]</dd>
    <dt>".__('City / Locality')."</dt>
    <dd>".$result_array['city']."</dd>
</dl>
";

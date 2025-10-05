<?php
$phpgate_the_same_ip=false;
if (isset($_SERVER['SERVER_ADDR']) && isset($_SERVER['REMOTE_ADDR'])) {
    if ($_SERVER['REMOTE_ADDR']=="127.0.0.1" || $_SERVER['SERVER_ADDR'] == $_SERVER['REMOTE_ADDR']) $phpgate_the_same_ip=true;
}
if (isset($_SERVER['HTTP_USER_AGENT'])) {
    if (strpos($_SERVER['HTTP_USER_AGENT'], "MJ12bot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "SemrushBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "ahrefs.com")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "AhrefsBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "dotbot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Dotbot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "DotBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "DynatraceSynthetic")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Buck/")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "PetalBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "GrapeshotCrawler")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "YandexBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Seekport")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "BLEXBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "ClaudeBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "ChatGPT")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "GPTBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Amazonbot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Applebot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Mediatoolkitbot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "trendictionbot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "SirdataBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Go-http-client")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Apache-HttpClient/")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Python/")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Python-urllib")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "python-requests")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "SeekportBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "AspiegelBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "IonCrawl")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "emailcollector")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "emailsiphon")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Baiduspider")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Bytespider")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Barkrowler")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "OAI-SearchBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "SentiBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Awario")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "cert-manager/v")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Mail.RU_Bot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "RSiteAuditor")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "GuzzleHttp")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Dalvik")!==false && isset($phpgate_agent_skip_dalvik)==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "FreshpingBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "smartocto-bot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Ruby")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "ImagesiftBot")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "Scrapy")!==false) phpgate_cut_request();
    if (strpos($_SERVER['HTTP_USER_AGENT'], "SeznamBot")!==false) phpgate_cut_request();
    if (isset($phpgate_skip_empty_agent_string_check)==false && $_SERVER['HTTP_USER_AGENT'] == "" && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
    if (isset($phpgate_skip_empty_agent_string_check)==false && $_SERVER['HTTP_USER_AGENT'] == "-" && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
} else {
    if (isset($phpgate_skip_empty_agent_string_check)==false && isset($_SERVER['REQUEST_URI']) && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
}

if (isset($_SERVER['REQUEST_URI'])) {
    if (strpos($_SERVER['REQUEST_URI'], "_rstr_nocache")!==false) phpgate_cut_request();
}

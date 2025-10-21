<?php

function phpgate_bot_detected($agent_string, $block_after) {
    if ($block_after == -1) {
        phpgate_cut_request();
    }
    if ($block_after > 0) {
        phpgate_count_limit_bot($agent_string, $block_after);
    }

}

if (isset($_SERVER['HTTP_USER_AGENT'])) {
    // -1 means instant block
    // 0 means do not block
    // >0 means block after X requests in the same minute

    $phpgate_agent_strings = array(
        "ClaudeBot" => 3,
        "ChatGPT" => 3,
        "GPTBot" => 3,
        "OAI-SearchBot" => 3,
        "meta-externalagent" => 3,
        // "Dalvik" => 3,
        "ahrefs.com" => 1,
        "AhrefsBot" => 1,
        "MJ12bot" => 1,
        "SemrushBot" => 1,
        "YandexBot" => 1,
        "Amazonbot" => 1,
        "Applebot" => 1,
        "dotbot" => -1,
        "Dotbot" => -1,
        "DotBot" => -1,
        "DynatraceSynthetic" => -1,
        "Buck/" => -1,
        "PetalBot" => -1,
        "GrapeshotCrawler" => -1,
        "Seekport" => -1,
        "BLEXBot" => -1,
        "Mediatoolkitbot" => -1,
        "trendictionbot" => -1,
        "SirdataBot" => -1,
        "Go-http-client" => -1,
        "Apache-HttpClient/" => -1,
        "Python/" => -1,
        "Python-urllib" => -1,
        "python-requests" => -1,
        "SeekportBot" => -1,
        "AspiegelBot" => -1,
        "IonCrawl" => -1,
        "emailcollector" => -1,
        "emailsiphon" => -1,
        "Baiduspider" => -1,
        "Bytespider" => -1,
        "Barkrowler" => -1,
        "SentiBot" => -1,
        "Awario" => -1,
        "cert-manager/v" => -1,
        "Mail.RU_Bot" => -1,
        "RSiteAuditor" => -1,
        "GuzzleHttp" => -1,
        "FreshpingBot" => -1,
        "smartocto-bot" => -1,
        "Ruby" => -1,
        "ImagesiftBot" => -1,
        "Scrapy" => -1,
        "SeznamBot" => -1
    );
    if (isset($phpgate_agent_strings_override)) {
        foreach ($phpgate_agent_strings_override as $agent_string => $block_after) {
            $phpgate_agent_strings[$agent_string] = $block_after;
        }
    }
    foreach ($phpgate_agent_strings as $agent_string => $block_after) {
        if (strpos($_SERVER['HTTP_USER_AGENT'], $agent_string)!==false) phpgate_bot_detected($agent_string, $block_after);
    }

    if (isset($phpgate_skip_empty_agent_string_check)==false && $_SERVER['HTTP_USER_AGENT'] == "" && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
    if (isset($phpgate_skip_empty_agent_string_check)==false && $_SERVER['HTTP_USER_AGENT'] == "-" && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
} else {
    if (isset($phpgate_skip_empty_agent_string_check)==false && isset($_SERVER['REQUEST_URI']) && $phpgate_the_same_ip==false) phpgate_cut_request("Your Browser Agent string is empty. Maybe your antivirus does it. Please turn it off if you want to view this site.\n");
}

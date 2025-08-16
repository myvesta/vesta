<?php
session_start();
define('NO_AUTH_REQUIRED',true);
$TAB = 'RESET PASSWORD';
$v_ip = $_SERVER['REMOTE_ADDR'];

if (isset($_SESSION['user'])) {
    header("Location: /list/user");
}

// Main include
include($_SERVER['DOCUMENT_ROOT']."/inc/main.php");

if ((!empty($_POST['user'])) && (empty($_POST['code']))) {

    // Check token
    if ((!isset($_REQUEST['token'])) || ($_SESSION['token'] != $_REQUEST['token'])) {
        die("Wrong token or missing token");
    }

    $v_user = escapeshellarg($_POST['user']);
    $user = $_POST['user'];
    $email = $_POST['email'];
    $cmd="/usr/bin/sudo /usr/local/vesta/bin/v-list-user";
    exec ($cmd." ".$v_user." json", $output, $return_var);
    if ( $return_var == 0 ) {
        $data = json_decode(implode('', $output), true);
        if (!is_array($data)) { $data = array(); }
        unset($output);
        exec("/usr/bin/sudo /usr/local/vesta/bin/v-get-user-value ".$v_user." RKEYEXP", $output, $return_var);
        $rkeyexp = trim(implode('', $output));
        if (strlen($rkeyexp)>9) $rkeyexp=intval($rkeyexp);
        unset($output);
        if ($rkeyexp === null || $rkeyexp < time() - 900) {
            if (isset($data[$user]['CONTACT']) && $email == $data[$user]['CONTACT']) {
                exec("/usr/bin/sudo /usr/local/vesta/bin/v-change-user-rkey ".$v_user, $output, $return_var);
                unset($output);
                $CMD="/usr/bin/sudo /usr/local/vesta/bin/v-get-user-value ".$v_user." RKEY";
                exec($CMD, $output, $return_var);
                $rkey = trim(implode('', $output));
                //unset($output);
                //echo $rkey; exit;
                //echo $CMD."\n<br />";
                //var_dump($rkey); exit;
                $fname = isset($data[$user]['FNAME']) ? $data[$user]['FNAME'] : '';
                $lname = isset($data[$user]['LNAME']) ? $data[$user]['LNAME'] : '';
                $contact = isset($data[$user]['CONTACT']) ? $data[$user]['CONTACT'] : '';
                $to = isset($data[$user]['CONTACT']) ? $data[$user]['CONTACT'] : '';
                $subject = __('MAIL_RESET_SUBJECT',date("Y-m-d H:i:s"));
                $hostname = exec('hostname');
                $from = __('MAIL_FROM',$hostname);
                if (!empty($fname)) {
                    $mailtext = __('GREETINGS_GORDON_FREEMAN',$fname,$lname);        
                } else {
                    $mailtext = __('GREETINGS');
                }
                $mailtext .= __('PASSWORD_RESET_REQUEST',$hostname.":".$_SERVER['SERVER_PORT'],$user,$rkey,$hostname.":".$_SERVER['SERVER_PORT'],$user,$rkey);
                if (!empty($rkey)) {
                    send_email($to, $subject, $mailtext, $from);
                    header("Location: /reset/?action=code&user=".$_POST['user']);
                }
            } else {
                $ERROR = "<a class=\"error\">".__('User and email not matched')."</a>";
                exec("/usr/bin/sudo /usr/local/vesta/bin/v-log-failed-login " . $v_user . " " . $v_ip, $output, $return_var);
            }
        } else {
            $ERROR = "<a class=\"error\">".__('Please wait 15 minutes before sending a new request')."</a>";
        }
    } else {
        $ERROR = "<a class=\"error\">".__('User and email not matched')."</a>";
    }
    unset($output);
}

if ((!empty($_POST['user'])) && (!empty($_POST['code'])) && (!empty($_POST['password'])) ) {

    // Check token
    if ((!isset($_REQUEST['token'])) || ($_SESSION['token'] != $_REQUEST['token'])) {
        die("Wrong token or missing token");
    }

    if ( $_POST['password'] == $_POST['password_confirm'] ) {
        $v_user = escapeshellarg($_POST['user']);
        $user = $_POST['user'];
        $cmd="/usr/bin/sudo /usr/local/vesta/bin/v-list-user";
        exec ($cmd." ".$v_user." json", $output, $return_var);
        if ( $return_var == 0 ) {
            $data = json_decode(implode('', $output), true);
            if (!is_array($data)) { $data = array(); }
            unset($output);
            $rkey = isset($data[$user]['RKEY']) ? $data[$user]['RKEY'] : '';
            if (hash_equals($rkey, $_POST['code'])) {
                unset($output);
                exec("/usr/bin/sudo /usr/local/vesta/bin/v-get-user-value ".$v_user." RKEYEXP", $output, $return_var);
                $rkeyexp = trim(implode('', $output));
                if (strlen($rkeyexp)>9) $rkeyexp=intval($rkeyexp);
                unset($output);
                if ($rkeyexp > time() - 900) {
                    $v_password = tempnam("/tmp","vst");
                    $fp = fopen($v_password, "w");
                    fwrite($fp, $_POST['password']."\n");
                    fclose($fp);
                    $cmd="/usr/bin/sudo /usr/local/vesta/bin/v-change-user-password";
                    exec ($cmd." ".$v_user." ".$v_password, $output, $return_var);
                    unlink($v_password);
                    if ( $return_var > 0 ) {
                        sleep(5);
                        $ERROR = "<a class=\"error\">".__('An internal error occurred')."</a>";
                    } else {
                        $_SESSION['user'] = $_POST['user'];
                        header("Location: /");
                        exit;
                    }
                } else {
                    sleep(5);
                    $ERROR = "<a class=\"error\">".__('Code has been expired')."</a>";
                    exec("/usr/bin/sudo /usr/local/vesta/bin/v-log-failed-login " . $v_user . " " . $v_ip, $output, $return_var);
                }
            } else {
                sleep(5);
                $ERROR = "<a class=\"error\">".__('Invalid username or code')."</a>";
                exec("/usr/bin/sudo /usr/local/vesta/bin/v-log-failed-login " . $v_user . " " . $v_ip, $output, $return_var);
            }
        } else {
            sleep(5);
            $ERROR = "<a class=\"error\">".__('Invalid username or code')."</a>";
        }
    } else {
        $ERROR = "<a class=\"error\">".__('Passwords not match')."</a>";
    }
}

// Detect language
if (empty($_SESSION['language'])) $_SESSION['language'] = detect_user_language();

if (empty($_GET['action'])) {
    require_once '../templates/header.html';
    require_once '../templates/reset_1.html';
} else {
    require_once '../templates/header.html';
    if ($_GET['action'] == 'code' ) {
        require_once '../templates/reset_2.html';
    }
    if (($_GET['action'] == 'confirm' ) && (!empty($_GET['code']))) {
        require_once '../templates/reset_3.html';
    }
}

?>

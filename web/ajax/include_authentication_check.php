<?php

if (isset($authentication_check_this_is_nested_script) == false) die('$authentication_check_this_is_nested_script not set in '.$_SERVER['REQUEST_URI']);

if ($authentication_check_this_is_nested_script == false) {
    
    if (isset($authentication_check_loaded) == false) {
        include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");
    }

} else {

    if (!isset($authentication_check_loaded)) die('Authentication check not loaded in nested script');

}
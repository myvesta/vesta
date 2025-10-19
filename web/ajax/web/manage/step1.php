<?php

// Main include
$required_dataset_param = 'domain';
include($_SERVER['DOCUMENT_ROOT']."/ajax/authentication_check.php");
include($_SERVER['DOCUMENT_ROOT']."/inc/form-elements.php");

echo 'Ajax script: web / manage, step1, Domain: '.$domain;
?>

<br /><br />
<form id="floating-center-div-form" name="floating-center-div-form" method="post" action="/ajax/web/manage/step2.php">
    <input type="hidden" name="token" value="<?=$_SESSION['token']?>" />
    <?php
    if (isset($_POST['dataset'])) {
        foreach ($_POST['dataset'] as $key => $value) { 
            echo '<input type="hidden" name="dataset['.$key.']" value="'.$value.'" />';
        }
    }
    ?>

    <!--
    <input type="hidden" name="confirm_required" value="1" id="confirm_required" />
    <input type="hidden" name="confirm_required_default_value" value="yes" id="confirm_required_default_value" />
    <input type="hidden" name="confirm_required_title" value="Confirm" id="confirm_required_title" />
    <input type="hidden" name="confirm_required_content" value="Are you sure you want to continue?" id="confirm_required_content" />
    <input type="hidden" name="confirm_required_type" value="confirm" id="confirm_required_type" />
    <input type="hidden" name="confirm_required_selected_button" value="no" id="confirm_required_selected_button" />
    <input type="hidden" name="confirm_required_callback" value="TESTFUNCTION" id="confirm_required_callback" />
    -->

    <?php
        echo myvesta_get_element('input', 'Variable 1:', 'var1', 'val1');
        echo myvesta_get_element('textarea', 'Variable 2:', 'var2', 'val2'); 
        echo myvesta_get_element('listbox', 'Variable 3:', 'var3', array('1' => 'Option 1', '2' => 'Option 2', '3' => 'Option 3'), '2');
    ?>

    <br />
    <button type="submit" class="button ajax-button-margin-top">Submit</button>
</form>
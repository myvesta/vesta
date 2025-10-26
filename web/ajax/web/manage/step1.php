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

        echo myvesta_get_confirtmation_hidden_fields();
        echo myvesta_get_element('input', 'Variable 1:', 'var1', 'val1');
        echo myvesta_get_element('textarea', 'Variable 2:', 'var2', 'val2'); 
        echo myvesta_get_element('listbox', 'Variable 3:', 'var3', array('1' => 'Option 1', '2' => 'Option 2', '3' => 'Option 3'), '2');
    ?>
    <br />
    <button type="submit" class="button ajax-button-margin-top">Submit</button>
</form>
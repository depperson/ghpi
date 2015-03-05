<?php

// configure Dwoo template
include 'lib/dwooAutoload.php';
$dwoo = new Dwoo();
$tepl = new Dwoo_Template_File('templates/settings.tpl');
$data = array();


// open the db
if (!($db = new PDO('sqlite:ghpi.db'))) 
{
    $notice_text = 'Failed to open the database ghpi.db.';  
    $notice_level = 'danger';
    $data['noticetext'] = $notice_text;
    $data['noticelevel'] = $notice_level;
    $dwoo->output($tepl, $data);
    die('Failed to open the database /opt/ghpi/www/ghpi.db.');
}


// update the zipcode
if (isset($_POST["zip"])) 
{
    $zip = (int) $_POST["zip"];
    $sql = "UPDATE settings SET value=? WHERE name='zip'";
    $res = $db->prepare($sql); 
    $res->execute(array($zip));  
    $err = $db->errorInfo();
    if ($err[0] != '00000')
    {
        $notice_text = '<b>Error!</b>  The db update failed. ';
	$notice_level = 'danger';
    } else {
        $notice_text = '<b>Success!</b>  The new zipcode '. $zip .' was saved.';
        $notice_level = 'success';
    }
} else {

    // get the zip from the db
    $res = $db->prepare("SELECT value FROM settings WHERE name='zip' LIMIT 1;");
    $res->execute();
    $row = $res->fetch();
    if ($row) $zip = $row[0];

} // end zipcode post if


// list the sensors from db
$res = $db->prepare("SELECT name,address FROM sensors;");
$res->execute();
$sensors = $res->fetchAll(PDO::FETCH_ASSOC);
//print_r($sensors);


// output the template
$data['zip']        = $zip;
$data['mode']       = $mode;
$data['sensore']    = $sensore;
$data['sensors']    = $sensors;
$data['noticetext'] = $notice_text;
$data['noticelevel']= $notice_level;
$dwoo->output($tepl, $data);


?>

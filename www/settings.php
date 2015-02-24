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
    die('Failed to open the database ghpi.db.');
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


// add a sensor
if (isset($_POST["add"]))
{
    if (isset($_POST["sensor"]) && isset($_POST["desc"]))
    {
        
        $res = $db->prepare("INSERT INTO settings (name, value)
                VALUES ('". $_POST["sensor"] ."', '". $_POST["desc"] ."');");
        $res->execute();
        $err = $db->errorInfo();
        if ($err[0] != '00000')
        {
            $data['noticetext'] = '<b>Error!</b>  The db update failed for '. $_POST["sensor"] .'.';
            $data['noticelevel']= 'danger';
            $dwoo->output($tepl, $data);
            die('Error writing sensor to db.');
        } else {
            $notice_text = '<b>Success!</b>  Sensor '. $_POST["sensor"] .' was added.';
            $notice_level = 'success';
        }
    }
} // end sensor add if


// edit a sensor
if (isset($_GET['mode']) && ($_GET["mode"] == "edit"))
{
    $mode = "edit";
    if (isset($_GET['sensor']))
    {
        $res = $db->prepare("SELECT name,value FROM settings WHERE name='". $_GET['sensor'] ."';");
        $res->execute();
        $sensore = $res->fetch(PDO::FETCH_ASSOC);
    }
} // end sensor edit if


// save sensor edit
if (isset($_POST["edit"]))
{
    if (isset($_POST["sensor"]) && isset($_POST["desc"]))
    {
        $res = $db->prepare("   UPDATE settings 
                                SET value='". $_POST['desc'] ."' 
                                WHERE name='".$_POST['sensor'] ."';");
        $res->execute();
        $err = $db->errorInfo();
        if ($err[0] != '00000')
        {
            $data['noticetext'] = '<b>Error!</b>  The db update failed for '. $_POST["sensor"] .'.';
            $data['noticelevel']= 'danger';
            $dwoo->output($tepl, $data);
            die('Error writing sensor to db.');
        } else {
            $notice_text = '<b>Success!</b>  Sensor '. $_POST["sensor"] .' was saved.';
            $notice_level = 'success';
        }
    }
}

// scan for wired sensors
if (isset($_GET['mode']) && ($_GET["mode"] == "scan"))
{
    // find all wired 1-wire sensors
    $mode = "scan";
    $files = glob("/sys/bus/w1/devices/28*");
    $added = 0;
    foreach ($files as $file)
    {
        // 28-00043ebcf0ff is a sensor name
        $sensorname = basename($file);
        $res = $db->prepare("SELECT value FROM settings WHERE name='$sensorname' LIMIT 1;");
        $res->execute();
        $row = $res->fetch();
        if (!$row)
        {
            // this sensor is not in the db, add it
            $added += 1;
            $res = $db->prepare("INSERT INTO settings (name, value)
                    VALUES ('$sensorname', 'sensor $sensorname');");
            $res->execute();
            $err = $db->errorInfo();
            if ($err[0] != '00000')
            {
                $data['noticetext'] = '<b>Error!</b>  The db update failed for '. $sensorname .'.';
                $data['noticelevel']= 'danger';
                $dwoo->output($tepl, $data);
                die('Error writing sensor to db.');
            } else {
                $notice_text = '<b>Success!</b>  '. $added .' sensors were added.';
                $notice_level = 'success';
            }
        } // end row if
    } // end $files foreach
    if ($added == 0)
    {
        $notice_text = '<b>Warning:</b>  No new sensors were found.';
        $notice_level = 'warning';
    }
} // end scan mode if


// list the sensors from db
$res = $db->prepare("SELECT name,value FROM settings WHERE name LIKE '28%';");
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

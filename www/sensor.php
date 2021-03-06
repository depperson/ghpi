<?php

// configure Dwoo template
include 'lib/dwooAutoload.php';
$dwoo = new Dwoo();
$data = array();
$template = 'templates/sensor.tpl';


// open the db
if (!($db = new PDO('sqlite:ghpi.db'))) 
{
    $data['noticetext'] = 'Failed to open the database ghpi.db.';
    $data['noticelevel'] = 'danger';
    $dwoo->output($tepl, $data);
    die('Failed to open the database ghpi.db.');
}


// add a sensor
if (isset($_POST["add"]))
{
    if (isset($_POST["sensor"]) && isset($_POST["desc"]))
    {

        $res = $db->prepare("INSERT INTO sensors (address, name) VALUES (?,?)");
        $res->execute(array($_POST["sensor"], $_POST["desc"]));
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


// view/edit a sensor
if (isset($_GET["sensor"]))
{
    $template = "templates/sensoredit.tpl";
    $res = $db->prepare("SELECT address, name FROM sensors WHERE address=?");
    $res->execute(array($_GET['sensor']));
    $sensor = $res->fetch(PDO::FETCH_ASSOC);
    $files = glob("/opt/ghpi/www/graphs/*-" . $_GET['sensor'] . ".rrd.png");
    foreach($files as $filename)
    {
        $imagelist[] = basename($filename);
    }
} // end sensor edit if


// save sensor edit
if (isset($_POST["edit"]))
{
    if (isset($_POST["address"]) && isset($_POST["name"]))
    {
        $res = $db->prepare("UPDATE sensors SET name=? WHERE address=?;");
        $res->execute(array($_POST["name"], $_POST["address"]));
        $err = $db->errorInfo();
        if ($err[0] != '00000')
        {
            $data['noticetext'] = '<b>Error!</b>  The db update failed for '. $_POST["address"] .'.';
            $data['noticelevel']= 'danger';
            $dwoo->output($tepl, $data);
            die('Error writing sensor to db.');
        } else {
            $notice_text = '<b>Success!</b>  Sensor '. $_POST["address"] .' was saved.';
            $notice_level = 'success';
        }
    }
}


// scan for wired sensors
if ($_GET['mode'] == "scan")
{
    // find all wired 1-wire sensors
    $files = glob("/sys/bus/w1/devices/28*");
    $added = 0;
    foreach ($files as $file)
    {
        // 28-00043ebcf0ff is a sensor name
        $sensorname = basename($file);
        $res = $db->prepare("SELECT address FROM sensors WHERE address=? LIMIT 1;");
        $res->execute(array($sensorname));
        $row = $res->fetch();
        if (!$row)
        {
            // this sensor is not in the db, add it
            $added += 1;
            $res = $db->prepare("INSERT INTO sensors (address) VALUES (?);");
            $res->execute(array($sensorname));
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
$res = $db->prepare("SELECT address, name FROM sensors;");
$res->execute();
$sensors = $res->fetchAll(PDO::FETCH_ASSOC);
//print_r($rows);


// output the template
$tepl = new Dwoo_Template_File($template);
#$data['mode']       = $_GET['mode'];
$data['zip']        = $zip;
$data['files']      = $imagelist;
$data['noticetext'] = $notice_text;
$data['noticelevel']= $notice_level;
$data['sensor']    = $sensor;
$data['sensors']    = $sensors;
$dwoo->output($tepl, $data);


?>

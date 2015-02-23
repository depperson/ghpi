<!DOCTYPE html>
<html>
<head>
	<meta name="author" content="depperson@gmail.com">
	<meta name="viewport" content="initial-scale=0.5">
<?php
if ($db = new PDO('sqlite:ghpi.db')) {
	$result = $db->query("SELECT * from settings;");
	if (!$result) {
		echo '	<meta http-equiv="refresh" content="4; url=settings.php">';
	} else {
		echo '	<meta http-equiv="refresh" content="600">';
	}
} else {
	// db failure
	echo '</head>db error</html>';
}
?>

	<link rel="stylesheet" type="text/css" href="style.css">
	<title>ghTemp</title>
</head>

<body style="background-image: url('gh2.png'); background-repeat: no-repeat;">
<?php

// get last update for a given sensor and display some html
function display_sensor($sensor) {
	$rrdlast = rrd_lastupdate("/opt/ghpi/rrd/temps-". $sensor .".rrd");
	//print_r($return);


	$age = time() - $rrdlast['last_update'];
	if ($age > 600)
	{
		// data is over 10 minutes old
		echo 'class="tempboxbad"><a href="graphs.php?sensor=' . $sensor . '"> offline' . "</a></div>\r\n";

	} else {
		$tempf = $rrdlast['data'][0];
	        if (($tempf > 30) && ($tempf < 100)) {
        	        echo 'class="tempbox"><a href="graphs.php?sensor=' . $sensor . '">';
	        } else {
        	        echo 'class="tempboxbad"><a href="graphs.php?sensor=' . $sensor .'">';
	        }
		echo $tempf . "</a></div>\r\n";
	}
}
?>

<div class="statusboxbad" id="topstatus">checking...</div>
<div class="midstatusboxbad" id="midstatus">checking...</div>

<!-- weather //-->
<div style="position:absolute; top: 380px; left: 280px; width:305px; height:105px;">
<a href="http://www.wunderground.com/cgi-bin/findweather/getForecast?query=zmw:78655.1.99999&bannertypeclick=wu_clean2day" title="Martindale, Texas Weather Forecast" target="_blank"><img src="http://weathersticker.wunderground.com/weathersticker/cgi-bin/banner/ban/wxBanner?bannertype=wu_clean2day_cond&airportcode=KHYI&ForcedCity=Martindale&ForcedState=TX&zip=78655&language=EN" alt="Find more about Weather in Martindale, TX" width="300" /></a>
</div>

<!-- top //-->
<div style="top:270px; left: 310px;" <?php display_sensor("28-00043ebcf0ff"); ?>
<!--
<div style="top:270px; left: 310px;" <?php display_sensor("28fff0bc3e04007c"); ?>
<div style="top:170px; left: 440px;" <?php display_sensor("28ff15863d0400c3"); ?>
<div style="top:270px; left: 440px;" <?php display_sensor("28ffaf442c0400ee"); ?>
--//>

<!-- middle to left expansion 
<div style="top:1000px; left: 220px;" class="tempboxoff">off</div>
<div style="top:1120px; left: 220px;" class="tempboxoff">off</div>
<div style="top:1360px; left: 220px;" class="tempboxoff">off</div>
<div style="top:1520px; left: 220px;" class="tempboxoff">off</div>

<!-- main row
<div style="top:660px; left: 420px;" class="tempboxoff">off</div>
<div style="top:770px; left: 420px;" class="tempboxoff">off</div>
<div style="top:880px; left: 420px;" class="tempboxoff">off</div>
<div style="top:825px; left: 420px;" <?php display_sensor("28-00043ebdabff"); ?>
<div style="top:935px; left: 420px;" <?php display_sensor("28-00043ec125ff"); ?>
<div style="top:1100px; left: 420px;" <?php display_sensor("28-00042c4940ff"); ?>
<div style="top:1210px; left: 420px;" <?php display_sensor("28-00042c493cff"); ?>

<!-- main row - middle 
<div style="top:1265px; left: 420px;" id="middlehouse" <?php display_sensor("28-00042c4497ff"); ?>

<!-- main row - bottom 
<div style="top:1430px; left: 420px;" <?php display_sensor("28-00043d87d2ff"); ?>

<!-- "hidden" link //-->
<div style="position:absolute; top:2150px; left: 60px;">
 <a href="system.php"> &nbsp; </a>
</div>

<!-- end of the map section //-->
<div style="	clear:both;width:100%;position:relative;
		margin-top:2240px;"> &nbsp; </div>

<?php include 'footer.php'; ?>

<p> &nbsp; </p>

<!-- check for alarms, color the status box //-->
<script src="status.js"></script>

</body>
</html>

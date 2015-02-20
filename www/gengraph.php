<html>
<head>
 <meta name="viewport" content="initial-scale=0.7">
 <link rel="stylesheet" type="text/css" href="style.css">
 <title>ghTemp - Custom Graph</title>
</head>
<body style="padding:4px;">

<img src="graphs/custom.png"/>

<?php

$sensor = empty($_GET['sensor']) ? "28-00042c4940ff" : $_GET['sensor'];
$start 	= empty($_GET['start']) ? "-1h" : $_GET['start'];
$end	= empty($_GET['stop']) ? "now" : $_GET['stop'];
$upper	= empty($_GET['upper']) ? "100" : $_GET['upper'];
$lower	= empty($_GET['lower']) ? "30" : $_GET['lower'];

if ($sensor == "system") {
	$rrdfile = "cputemp.rrd";
} else {
	$rrdfile = 'temps-' . $sensor . '.rrd';
}

//echo $rrdfile . "<br/>\r\n";

$options = array(
	"-w 350", "-h 120", "-u ". $upper, "-l ". $lower,
	"--slope-mode",
        "--start=" . $start,
	"--end=" . $end,
        "--title=from ". $sensor, 
        "--vertical-label=temperature",
        "--right-axis=1:0",
        "--alt-y-grid", "--rigid",
        "DEF:tempa=/opt/ghpi/rrd/" . $rrdfile . ":t:AVERAGE",
        "AREA:tempa#CCCCCC:average",
        "DEF:temp=/opt/ghpi/rrd/" . $rrdfile . ":t:MAX",
        "LINE2:temp#0000FF:maximum",
        "GPRINT:temp:AVERAGE:Avg\: %5.2lf",
        "GPRINT:temp:MAX:Max\: %5.2lf",
       	"GPRINT:temp:MIN:Min\: %5.2lf\t\t\t",
);
//print_r($options);

$retval = rrd_graph("/opt/ghpi/www/graphs/custom.png", $options);
if (! $retval) {
	echo "<b>Graph error " . $retval . ": </b>" . rrd_error() ."\n";
}
?>

<p>
	<form method="get">
	<input name="sensor" type="hidden" value="<?php echo $sensor; ?>"/>
	start <input name="start" value="<?php echo $start; ?>" size=10/> 
	stop <input name="stop" value="<?php echo $end; ?>" size=10/> 
	upper <input name="upper" value="<?php echo $upper; ?>" size=6/> 
	lower <input name="lower" value="<?php echo $lower; ?>" size=6/> 
	<br/>
	<br/>
	<input type="submit" value="generate"/>
	</form>
</p>

<br/><br/>
<?php include 'footer.php'; ?>

</body>
</html>

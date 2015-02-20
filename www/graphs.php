<html>
<head>
 <meta name="viewport" content="initial-scale=0.7">
 <meta http-equiv="refresh" content="600">
 <link rel="stylesheet" type="text/css" href="style.css">
 <title>ghTemp - Graphs</title>
</head>
<body style="padding:4px;">

<?php
$sensor = $_GET['sensor'];

function displayfiles($infiles, $insensor="") {
	foreach ($infiles as $file) {
		$base = basename($file);
		$sensorname = split('-', $base, 5)[4];
		$sensorname = substr($sensorname, 0, -8);
		//echo $sensorname;
		//echo $sensor;
		//echo '<h2>' . $base . '</h2>';

		if ($insensor != "") {
			echo '<a href="graphs/'. $base .'"><img src="graphs/' . $base .'"/></a>';
		} else {
			echo '<a href="graphs.php?sensor=' . $sensorname . '">'
				. '<img src="graphs/' . $base .'"/></a>';
		}
		echo "\r\n";
	}
}

if ($sensor != "") {

	// graphs for a specific sensor
	echo "<h3>sensor " . $sensor . " - "
		. '<a href="gengraph.php?sensor=' . $sensor . '">custom graph</a>'
		. "</h3>";
	echo "\r\n";

	$files = glob("/opt/ghpi/www/graphs/*-" . $sensor . ".rrd.png");
	displayfiles($files, $sensor);

} else {

	// 6h graphs
	echo "<h3>all sensors - 6h</h3>";
	echo "\r\n";
	$files = glob("/opt/ghpi/www/graphs/6h-*");
	displayfiles($files);
	echo "<br/>\r\n";
	
	// 24h graphs
	echo "<h3>all sensors - 24h</h3>";
	echo "\r\n";
	$files = glob("/opt/ghpi/www/graphs/1d-*");
	displayfiles($files);
	echo "<br/>\r\n";
	
	// 48h graphs
	echo "<h3>all sensors - 48h</h3>";
	echo "\r\n";
	$files = glob("/opt/ghpi/www/graphs/2d-*");
	displayfiles($files);
	echo "<br/>\r\n";

	// 7d graphs
	echo "<h3>all sensors - 7d</h3>";
	echo "\r\n";
	$files = glob("/opt/ghpi/www/graphs/7d-*");
	displayfiles($files);
	echo "<br/>\r\n";

}


?>
<br/><br/>


<?php include 'footer.php'; ?>

</body>
</html>

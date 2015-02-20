<!DOCTYPE html>
<html>
<head>
        <meta name="author" content="depperson@gmail.com">
	<link rel="stylesheet" type="text/css" href="style.css">
        <title>ghTemp - System Information</title>
</head>
<body>
<a href="gengraph.php?sensor=system">Temperature graph</a>

<?php
$time = microtime();
$time = explode(' ', $time);
$time = $time[1] + $time[0];
$start = $time;

$output = shell_exec(	'date; uptime; echo; '
			. 'echo /proc/meminfo; cat /proc/meminfo; echo; '
			. 'echo ps auxf; ps auxf; echo; '
			. 'echo df -h; df -h; echo; '
			. 'echo sar -ur; sar -ur; echo; '
			. 'echo cpu temp in celcius; '
			. 'expr $(cat /sys/class/thermal/thermal_zone0/temp) / 1000; echo; '
			. 'echo ifconfig -a; ifconfig -a; echo; ' 
			. 'echo ls -la /sys/bus/w1/devices; ls -la /sys/bus/w1/devices; echo; '
			);
echo "<pre>$output</pre>\r\n";

$time = microtime();
$time = explode(' ', $time);
$time = $time[1] + $time[0];
$finish = $time;
$total_time = round(($finish - $start), 4);
echo 'Page generated in '. $total_time ." seconds.\r\n";

include 'footer.php'; 
?>

</body>
</html>


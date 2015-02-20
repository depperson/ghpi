#!/bin/bash
#

outdir="/home/pi/ghpi/www/graphs"

# find rrds
rrdfiles=$(/bin/ls /home/pi/ghpi/ | /bin/grep 'temps-.*.rrd')
echo Found RRDs $rrdfiles

for rrd in $rrdfiles;
do
	echo Graphing $rrd

	# get sensor name and description
	sensor=$(echo $rrd | cut -d'-' -f2- | cut -d. -f1)
	desc=$(grep $sensor /home/pi/ghpi/sensors.csv | cut -d',' -f2-)
	if [ -z "$desc" ];
	then
		desc=$sensor
	fi
	

	# 6hr
	/usr/bin/rrdtool graph $outdir/graph-1-06h-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--start -21600 --end now \
	--slope-mode \
	--font DEFAULT:7: \
	--title "last 6h from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid MINUTE:10:HOUR:1:MINUTE:120:0:%I%p \
	--alt-y-grid --rigid \
	DEF:tempa=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:tempa#CCCCCC:"average" \
	DEF:temp=/home/pi/ghpi/$rrd:t:MAX \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:LAST:"Cur\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

	# 24hr graph
	/usr/bin/rrdtool graph $outdir/graph-2-24h-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--start -86400 --end now \
	--slope-mode \
	--font DEFAULT:7: \
	--title "last 24h from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid MINUTE:30:HOUR:2:MINUTE:240:0:%I%p \
	--alt-y-grid --rigid \
	DEF:tempa=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:tempa#CCCCCC:"average" \
	DEF:temp=/home/pi/ghpi/$rrd:t:MAX \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

	# 48hr graph
	/usr/bin/rrdtool graph $outdir/graph-3-48h-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--start -48h --end now \
	--slope-mode \
	--font DEFAULT:7: \
	--title "last 2d from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--alt-y-grid --rigid \
	DEF:tempa=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:tempa#CCCCCC:"average" \
	DEF:temp=/home/pi/ghpi/$rrd:t:MAX \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

done


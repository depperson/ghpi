#!/bin/bash
#

outdir="/home/pi/ghpi/www/graphs"

# find rrds
#rrdfiles=$(/bin/ls /home/pi/ghpi/ | /bin/grep 'temps-28-0004.*.rrd')
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

	# 7day
	/usr/bin/rrdtool graph $outdir/graph-5-7d-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--slope-mode \
	--start -7d --end now \
	--font DEFAULT:7: \
	--title "last 7d from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid HOUR:6:DAY:1:DAY:1:86400:%a \
	--alt-y-grid --rigid \
	DEF:tempa=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:tempa#CCCCCC:"average" \
	DEF:temp=/home/pi/ghpi/$rrd:t:MAX \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

	# 14day
	/usr/bin/rrdtool graph $outdir/graph-6-14d-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--slope-mode \
	--start -14d --end now \
	--font DEFAULT:7: \
	--title "last 14d from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid DAY:1:DAY:5:DAY:5:86400:%m/%d \
	--alt-y-grid --rigid \
	DEF:temp=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:temp#CCCCCC:"average" \
	LINE2:temp#0000FF:"average" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t"
 
	# 30day
	/usr/bin/rrdtool graph $outdir/graph-7-30d-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--slope-mode \
	--start -2592000 --end now \
	--font DEFAULT:7: \
	--title "last 30d from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid DAY:1:DAY:5:DAY:5:86400:%m/%d \
	--alt-y-grid --rigid \
	DEF:temp=/home/pi/ghpi/$rrd:t:AVERAGE \
	AREA:temp#CCCCCC:"average" \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

	# 3months
	/usr/bin/rrdtool graph $outdir/graph-8-3mo-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--slope-mode \
	--start -3mon --end now \
	--font DEFAULT:7: \
	--title "last 3mo from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--alt-y-grid --rigid \
	DEF:temp=/home/pi/ghpi/$rrd:t:AVERAGE:step=54000 \
	AREA:temp#CCCCCC:"average" \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

	# 1yr
	/usr/bin/rrdtool graph $outdir/graph-9-1yr-$rrd.png \
	-w 350 -h 120 -a PNG \
	-u 100 -l 30 \
	--slope-mode \
	--start -31557600 --end now \
	--font DEFAULT:7: \
	--title "last year from $desc" \
	--watermark "Generated on `date`" \
	--vertical-label "temperature" \
	--right-axis 1:0 \
	--x-grid DAY:25:DAY:25:DAY:25:86400:%b \
	--alt-y-grid --rigid \
	DEF:temp=/home/pi/ghpi/$rrd:t:AVERAGE:step=128000 \
	AREA:temp#CCCCCC:"average" \
	LINE2:temp#0000FF:"maximum" \
	GPRINT:temp:AVERAGE:"Avg\: %5.2lf" \
	GPRINT:temp:MAX:"Max\: %5.2lf" \
	GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t" 

done


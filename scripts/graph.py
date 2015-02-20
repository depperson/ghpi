#!/usr/bin/python
"""
The MIT License (MIT)

Copyright (c) 2015 Daniel Epperson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# This script generates PNGs from RRD files for a given time range. The expected
# use case is by a cron job. Usage should be fairly straightforward.


outpath = "/opt/ghpi/www/graphs/"
rrdpath = "/opt/ghpi/rrd/"


import rrdtool, glob, os, sys


def graph(time, rrdfile):
	if time not in ["6h", "1d", "2d", "7d", "14d", "1m", "3m", "1y"]:
		print "invalid time specified"
		sys.exit(1)

	if os.path.isfile(rrdfile):
		print "generating %s graph for %s" % (time, rrdfile)
		rrdfile = os.path.basename(rrdfile)
		outfile = outpath + rrdfile + "-hourly.png"
		rrdtool.graph(outfile, 	'-a', 'PNG',
				'-w', '350', '-h', '120',
				'-u 100', '-l', '30',
				'--start', '-%s' % time, '--end', 'now',
				'--slope-mode',
				'--font', 'DEFAULT:7:',
				'--title', '"last 6h from %s" rrdfile',
				'--watermark', '"Generated on "',
				'--vertical-label', '"temperature"',
				'--right-axis', '1:0',
				#'--x-grid', 'MINUTE:10:HOUR:1:MINUTE:120:0:%I%p',
				'--alt-y-grid', '--rigid',
				'DEF:tempa=' + rrdpath + rrdfile +':t:AVERAGE',
				'AREA:tempa#CCCCCC:"average"',
				'DEF:temp=' + rrdpath + rrdfile +':t:MAX',
				'LINE2:temp#0000FF:"maximum"',
				'GPRINT:temp:LAST:"Cur\: %5.2lf"',
				'GPRINT:temp:MAX:"Max\: %5.2lf"',
				'GPRINT:temp:MIN:"Min\: %5.2lf\t\t\t"' )


if len(sys.argv) == 1:
	print "Usage: ./graph.py <6h,1d,2d,7d,14d,1m,3m,1y> [rrd file path]"
	sys.exit(1)


# graph all rrds in rrdpath
if len(sys.argv) == 2:
	rrds = glob.glob(rrdpath + "*.rrd")
	for rrdfile in rrds:
		graph(sys.argv[1], rrdfile)


# graph one rrd
if len(sys.argv) == 3:
	rrdfile = rrdpath + sys.argv[2]
	if os.path.isfile(rrdfile):
		graph(sys.argv[1], rrdfile)
		
	else:
		print "rrd file %s not found" % rrdfile

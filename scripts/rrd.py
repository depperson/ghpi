#!/usr/bin/python


#
# MIT License
#
# This script handles interactions with the rrd files.
#


from rrdtool import update as rrd_update
from rrdtool import error as rrderror


def update_sensor(insensor, intemp):
    rrdfile = "/opt/ghpi/rrd/temps-%s.rrd" % insensor
    #print "rrdfile is %s" % rrdfile
    try:
        rrd_update(rrdfile, "N:%.1f" % intemp)
    except rrderror, e:
        print "rrd error %s" % e



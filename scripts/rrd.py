#!/usr/bin/python


#
# MIT License
#
# This script handles interactions with the rrd files.
#


import sys, glob, rrdtool
import database
valid_commands = ["scan"]

def update_sensor(insensor, intemp):
    rrdfile = "/opt/ghpi/rrd/temps-%s.rrd" % insensor
    #print "rrdfile is %s" % rrdfile
    try:
        rrdtool.update(rrdfile, "N:%.1f" % intemp)
    except rrdtool.error, e:
        print "rrd error %s" % e


def create_rrd(insensor):
    rrdfile = "/opt/ghpi/rrd/temps-%s.rrd" % insensor
    #print "rrdfile is %s" % rrdfile
    rrdtool.create(str(rrdfile),
                    "--step", "60",
                    "DS:t:GAUGE:240:0:120",
                    "RRA:MAX:0.5:1:15000",
                    "RRA:AVERAGE:0.5:5:5000",
                    "RRA:AVERAGE:0.5:10:5000",
                    "RRA:AVERAGE:0.5:30:5000",
                    "RRA:AVERAGE:0.5:120:5000",
                    "RRA:AVERAGE:0.5:480:5000",
                    "RRA:AVERAGE:0.5:720:1000")


def get_rrd_list():
    return glob.glob("/opt/ghpi/rrd/*.rrd")


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in valid_commands:
        print "Usage: ./rrd.py <scan>"
        sys.exit(1)
     
    if sys.argv[1] == "scan":
        sensors = database.get_sensor_list()
        rrds    = get_rrd_list()
        for sensor in sensors:
            if sensor not in rrds:
                print "creating rrd for %s" % sensor
                create_rrd(sensor)
        


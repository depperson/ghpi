#!/usr/bin/python


#
# MIT License
#
# This script is the local 1-wire temperature senor polling loop.
#


import os, glob, time, sys, sqlite3
import database

# thingspeak settings
import thingspeak
channel_id = 91574
write_key  = "JEMMA1CQ109N8FI3"

delay = 2
maxtries = 20
nosensors = 0


def find_sensors():
	os.chdir("/sys/bus/w1/devices/")
	return glob.glob("28-*")


def read_temp_raw(asensor):
	device_file = "/sys/bus/w1/devices/%s/w1_slave" % asensor
	#print "device_file is %s" % device_file
	try:
		f = open(device_file, 'r')
		lines = f.readlines()
		f.close()
		return lines
	except IOError as e:
    		print "sensor %s file i/o error" % asensor
	return ["", ""]


def read_temp(rsensor):
	lines = read_temp_raw(rsensor)
	tries = 1
	# ignore all 0 reads and failed CRCs
	while lines[0].strip()[-10:] == 'crc=00 YES' or lines[0].strip()[-3:] != 'YES' :
		tries += 1
		if tries > maxtries:
			#print "tries=%s" % tries
			break
		sleept = tries / 10.0
		#print "sleep=%f" % sleept
		time.sleep(sleept)
		lines = read_temp_raw(rsensor)
	if lines:
		equals_pos = lines[1].find('t=')
		if equals_pos != -1:
			temp_string = lines[1][equals_pos+2:]
			temp_c = float(temp_string) / 1000.0
			temp_f = temp_c * 9.0 / 5.0 + 32.0
			#print "tries=%s" % tries
			return temp_f, tries
	return (0.1234, tries)

conn = sqlite3.connect('/opt/ghpi/www/ghpi.db')
if conn is None:
    print "failed to open db /opt/ghpi/www/ghpi.db."
    sys.exit(1)


while True:
	sensors = find_sensors()
	if sensors:
		for sensor in sensors:
			temp,tries = read_temp(sensor)
			if temp == 0.1234:
				# there was an error
				continue
			print "sensor %s temp %.1f tries %s" % (sensor, temp, tries)

                        # update db
		        database.update_sensor(sensor, temp)
	
			# update the rrd
                        #rrd.update_sensor(sensor, temp)

			# update thingspeak
			channel = thingspeak.Channel(id=channel_id,write_key=write_key)
			response = channel.update({1:temp})
			print response

			time.sleep(delay)
	else:
		nosensors += 1
		print "no sensors %s" % nosensors
		if nosensors > 10:
			print "sudo reboot"


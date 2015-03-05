#!/usr/bin/python


#
# MIT License
#
# This script is the local 1-wire temperature senor polling loop.
#


import sys, sqlite3
conn = sqlite3.connect('/opt/ghpi/www/ghpi.db')
valid_commands = ["init", "drop", "dump"]


if len(sys.argv) != 2 or sys.argv[1] not in valid_commands:
    print "Usage: ./database.py <init|dump|drop>"
    sys.exit(1)


if sys.argv[1] == "init":
    conn.execute('''CREATE TABLE IF NOT EXISTS sensors (
                        address char(50) primary key not null, 
                        name, last, mapx, mapy)''')
    conn.execute('''CREATE TABLE IF NOT EXISTS settings (
                        name    char(50) primary key not null,
                        value)''')
    conn.commit()
    conn.execute('''INSERT INTO settings VALUES ('zip', '78704')''')
    conn.commit()
    conn.close()


if sys.argv[1] == "drop":
    conn.execute('''DROP TABLE IF EXISTS sensors''')
    conn.execute('''DROP TABLE IF EXISTS settings''')
    conn.commit()
    conn.close()


if sys.argv[1] == "dump":
    for row in conn.iterdump():
        print row
    conn.close()


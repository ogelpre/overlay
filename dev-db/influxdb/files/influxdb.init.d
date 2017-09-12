#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="Scalable datastore for metrics, events, and real-time analytics"

user="influxdb:influxdb"
logfile="/var/log/influxdb/influxd.log"
conffile="/etc/influxdb/influxdb.conf"
start_stop_daemon_args="--user $user --stdout $logfile --stderr $logfile"

command="/usr/bin/influxd"
command_args="
	-config $conffile 
	${INFLUXD_OPTS}
"

command_background=yes
pidfile=/run/influxdb.pid


depend() {
#    need net
    after bootmisc
    use dns logger 
}

start_pre() {
    checkpath --directory --owner $user --mode 0755 /var/lib/influxdb
    checkpath --directory --mode 0755 ${logfile%/*}
    checkpath --file --owner $user --mode 0644 $logfile
}

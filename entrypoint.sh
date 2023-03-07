#!/bin/bash

# Sets script to fail if any command fails.
set -e

set_xauth() {
	echo xauth add $DISPLAY . $XAUTH
	touch /.Xauthority
	xauth add $DISPLAY . $XAUTH
}

custom_properties() {
	if [ -f /jobs/kettle.properties ] ; then
		cp /jobs/kettle.properties $KETTLE_HOME
	fi
}

encr() {
	custom_properties
	# set the path to java so the encr.sh script will work
	. ./set-pentaho-env.sh
	setPentahoEnv
	export PATH=$PATH:$_PENTAHO_JAVA_HOME/bin
	./encr.sh -kettle $1
}

run_pan() {
	custom_properties
	echo ./pan.sh -file $@
	pan.sh -file /jobs/$@
}

run_kitchen() {
	custom_properties
	echo ./kitchen.sh -file $@
	kitchen.sh -file /jobs/$@
}

run_spoon() {
	custom_properties
	set_xauth
	echo /data-integration/spoon.sh
	/data-integration/spoon.sh
}

print_usage() {
echo "

Usage:	$0 COMMAND

Pentaho Data Integration (PDI)

Options:
  encr password		Obfuscate a password
  runj filename		Run job file
  runt filename		Run transformation file
  spoon			Run spoon (GUI)
  help		        Print this help
"
}

case "$1" in
    help)
        print_usage
        ;;
    encr)
	shift 1
        encr "$@"
        ;;
    runt)
	shift 1
        run_pan "$@"
        ;;
    runj)
	shift 1
        run_kitchen "$@"
        ;;
    spoon)
	run_spoon
        ;;
    *)
        exec "$@"
esac

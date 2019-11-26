#!/bin/bash

echo "FISHEYE_HOME=${FISHEYE_HOME}"
echo "FISHEYE_INST=${FISHEYE_INST}"

CONFIG_SOURCE="${FISHEYE_HOME:?"FISHEYE_HOME not set"}/config.xml"
CONFIG_DESTINATION="${FISHEYE_INST:?"FISHEYE_INST not set"}/config.xml"

if [ -f $CONFIG_DESTINATION ]; then
	echo "File $CONFIG_DESTINATION already exists."
	exit 0
fi

if [ ! -f $CONFIG_SOURCE ]; then
	echo "File $CONFIG_SOURCE doesn't exist."
	exit 1
fi

echo "Copying config.xml from ${CONFIG_SOURCE} to ${CONFIG_DESTINATION}..."
cp ${CONFIG_SOURCE} ${CONFIG_DESTINATION}

echo "Setting port to 8080 in ${CONFIG_DESTINATION}..."
sed -i.tmp "s/8060/8080/g" "$CONFIG_DESTINATION"

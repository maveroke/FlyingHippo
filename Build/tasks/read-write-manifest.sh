#!/bin/bash
# exit if a command fails
set -e

manifestFile="${1}"
key="${2}"
value="${3}"

if [ -z "${manifestFile}" ] ; then
	echo " [!] No target manifest file specified."
	exit 1
fi

if [ ! -f "${manifestFile}" ] ; then
	echo " [!] No manifest file exists at location: ${manifestFile}"
	exit 1
fi

if [ -z "${key}" ] ; then
	echo " [!] No Key specified!"
	exit 1
fi

originalValue="$(grep "${key}" ${manifestFile} | sed "s/.*${key}=\"//;s/\".*//")"

if [ -z "${originalValue}" ] ; then
  echo " [!] Could not find value for ${key}!"
  exit 1
fi

if [ -z "${value}" ] ; then
	# Read value if no replacement value specified
	echo "${originalValue}"
else
	# Write Value
	echo " [i] Original Value for ${key}: ${originalValue}"
	sed -i '' "s|${key}=\"${originalValue}\"|${key}=\"${value}\"|" "${manifestFile}"

	newValue="$(grep "${key}" ${manifestFile} | sed "s/.*${key}=\"//;s/\".*//")"
	echo " [i] New Value for ${key}: ${newValue}"
fi
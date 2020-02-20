#!/bin/bash
# exit if a command fails
set -e

plistFile="${1}"
key="${2}"
value="${3}"

if [ -z "${plistFile}" ] ; then
	echo " [!] No target plist file specified."
	exit 1
fi

if [ ! -f "${plistFile}" ] ; then
	echo " [!] No plist file exists at location: ${plistFile}"
	exit 1
fi

if [ -z "${key}" ] ; then
	echo " [!] No Key specified!"
	exit 1
fi

originalValue="$(/usr/libexec/PlistBuddy -c "Print :${key}" "${plistFile}")"

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
	/usr/libexec/PlistBuddy -c "Set :${key} ${value}" $plistFile

	newValue="$(/usr/libexec/PlistBuddy -c "Print :${key}" "${plistFile}")"
	echo " [i] New Value for ${key}: ${newValue}"
fi


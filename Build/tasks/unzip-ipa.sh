#!/bin/bash
# exit if a command fails
set -e
set -x

ipaFile="${1}"
outputDirectory="${2}"

if [ -z "${ipaFile}" ] ; then
	echo " [!] No target ipa specified."
	exit 1
fi

ipaName="$(basename "${ipaFile}" ".ipa")"

if [[ -z "${outputDirectory}" ]]; then
	outputDirectory="$(dirname $"{ipaFile}")/tmp"
fi

echo " [i] ipa File: ${ipaFile}"
echo " [i] ipa Name: ${ipaName}"
echo " [i] Output Directory: ${outputDirectory}"
mkdir -p "${outputDirectory}"

unzip -o -q "${ipaFile}" -d "${outputDirectory}"
rm -rf "${ipaFile}"

ls "${outputDirectory}"

app="$(find "${outputDirectory}" -name "*.app" -print -quit)"
echo " [i] Output: ${app}"
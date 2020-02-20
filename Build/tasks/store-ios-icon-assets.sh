#!/bin/bash
# exit if a command fails
set -e

assetsFolder="${1}"
plistFile="${2}"
outputDirectory="${3}"/actools

if [ -z "${assetsFolder}" ] ; then
	echo " [!] No target assets directory specified."
	exit 1
fi

if [ -f "${assetsFolder}" ] ; then
	echo " [!] Assets file doesn't exist."
	exit 1
fi

if [ -z "${plistFile}" ] ; then
	echo " [!] No target plist file specified."
	exit 1
fi

if [[ -z "${outputDirectory}" ]]; then
	outputDirectory="bin/actools"
fi

mkdir -p "${outputDirectory}"

# will build all appIcons that are specified by the project (In the first stage)
# Generate AppIcons folder
echo "${plistFile}"
minimumOSVersion="$(/usr/libexec/PlistBuddy -c "Print :MinimumOSVersion" "${plistFile}")"
echo " [i] ${minimumOSVersion}"

echo "Assets:			${assetsFolder}"
echo "Minimum OS Version:	${minimumOSVersion}"

appIconSets="$(find "$assetsFolder" -type d -name "*.appiconset" -mindepth 1 -print)"
for appIconSet in $appIconSets; do
	directoryName="$(basename "${appIconSet}" ".appiconset")"
	iconSetFolder="${outputDirectory}/${directoryName}"
	mkdir -p "${iconSetFolder}"
	echo "Compile:		${iconSetFolder}"
	echo "App Icon Name:		${directoryName}"
	echo "Partial Info plist:	${iconSetFolder}/Info.plist"

	actool "${assetsFolder}" --compile "${iconSetFolder}" --platform iphoneos --minimum-deployment-target "${minimumOSVersion}" --app-icon "${directoryName}" --output-partial-info-plist "${iconSetFolder}/Info.plist"
done
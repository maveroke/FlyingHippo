#!/bin/bash
# exit if a command fails
set -e
set -x

directory="${1}"
certificate="${2}" # $LIBRARY_CERTIFICATEALIAS

if [ -z "${directory}" ] ; then
	echo " [!] No target directory specified."
	exit 1
fi

if [ -z "${certificate}" ] ; then
	echo " [!] Apple Certificate specified."
	exit 1
fi

app="$(find "${directory}" -name "*.app" -print -quit)"
appName="$(basename "${app}" ".app")"
echo " [i] Application Target: ${app}"

# remove the signature
rm -rf "${app}/_CodeSignature"
# rm -r "${app}/SwiftFrameworksSimulator"

codesign -d --entitlements entitlements.xml "${app}/${appName}"
codesign --entitlements entitlements.xml -f -s "${certificate}" "${app}"

rm -rf entitlements.xml
# zip it back up
currentLocation=`PWD`
cd "${directory}"
zip --symlinks --verbose --recurse-paths "${appName}.ipa" "."
cd ${currentLocation}
rm -rf "${directory}/Payload"
# rm -rf "${directory}/SwiftSupport"
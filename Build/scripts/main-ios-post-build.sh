#!/bin/bash
# exit if a command fails
set -e

ipaFile="${1}"
outputDirectory="${2}/zips"
certificate="${3}"
provisioningProfileName="${4}"

sh artifactDirectory/unzip-ipa.sh "${ipaFile}" "${outputDirectory}"

application="$(find "${outputDirectory}" -name "*.app")"

sh artifactDirectory/package-swift.sh "${application}"
sh artifactDirectory/zip-ipa.sh "${outputDirectory}" "${certificate}" "${provisioningProfileName}"
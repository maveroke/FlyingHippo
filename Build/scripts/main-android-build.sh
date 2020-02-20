#!/bin/bash
# exit if a command fails
set -e

environment="${1}"
manifestTargetFile="${2}"
packageName="${3}"
appName="${4}"
appCenterKey="${5}"
outputDirectory="${6}"
lowerCaseEnvironment="$(echo "${environment}" | tr "[:upper:]" "[:lower:]")"

echo "environment: ${environment}"
echo "packageName: ${packageName}"
echo "outputDirectory: ${outputDirectory}"
echo "manifestTargetFile: ${manifestTargetFile}"
echo "lowerCaseEnvironment: ${lowerCaseEnvironment}"

icon="@mipmap/ic_${lowerCaseEnvironment}"
roundIcon="@mipmap/ic_${lowerCaseEnvironment}"_round
theme="@style/MainTheme_${lowerCaseEnvironment}"
label="${appName}"

if [[ "${environment}" != "PROD" ]]; then
	packageName="${packageName}_${lowerCaseEnvironment}"
	label="${environment}"
fi


sh "${outputDirectory}/read-write-manifest.sh" "${manifestTargetFile}" "android:icon" "${icon}"
sh "${outputDirectory}/read-write-manifest.sh" "${manifestTargetFile}" "android:roundIcon" "${roundIcon}"
sh "${outputDirectory}/read-write-manifest.sh" "${manifestTargetFile}" "android:theme" "${theme}"
sh "${outputDirectory}/read-write-manifest.sh" "${manifestTargetFile}" "android:label" "${label}"
sh "${outputDirectory}/read-write-manifest.sh" "${manifestTargetFile}" "package" "${packageName}"

"${outputDirectory}/exe/manifest-update" "${manifestTargetFile}" "AppCenterKey" "${appCenterKey}"
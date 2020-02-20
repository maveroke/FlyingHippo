#!/bin/bash
# exit if a command fails
set -e

environment="${1}"
plistTargetFile="${2}"
packageName="${3}"
appName="${4}"
outputDirectory="${5}"
lowerCaseEnvironment="$(echo "${environment}" | tr "[:upper:]" "[:lower:]")"

echo "environment: ${environment}"
echo "packageName: ${packageName}"
echo "outputDirectory: ${outputDirectory}"
echo "lowerCaseEnvironment: ${lowerCaseEnvironment}"

icon="AppIcon_${lowerCaseEnvironment}"
splashPage="LaunchScreen_${lowerCaseEnvironment}"
label="${appName}"

if [[ "${environment}" != "PROD" ]]; then
	packageName="${packageName}.${lowerCaseEnvironment}"
	label="${environment}"
fi

appDirectory="$(dirname "${plistTargetFile}")"
storyBoards="$(find "${appDirectory}" -iname "*.storyboardc")"
echo "appDirectory: $appDirectory"
for storyBoard in ${storyBoards}; do 
	fileName=$(basename "${storyBoard}" ".storyboardc")
	echo "storyBoard: $fileName"
	if [[ "${splashPage}" != "${fileName}" ]]; then
		rm -rf "${storyBoard}"
		echo "REMOVE storyBoard: $storyBoard"
	fi
done


sh "${outputDirectory}/app-icon.sh" "${outputDirectory}" "${icon}"

sh "${outputDirectory}/read-write-plist.sh" "${plistTargetFile}" "UILaunchStoryboardName" "${splashPage}" # splash page
sh "${outputDirectory}/read-write-plist.sh" "${plistTargetFile}" "CFBundleDisplayName" "${label}" # display name
sh "${outputDirectory}/read-write-plist.sh" "${plistTargetFile}" "CFBundleName" "${label}" # name 
sh "${outputDirectory}/read-write-plist.sh" "${plistTargetFile}" "CFBundleIdentifier" "${packageName}" # id


# sh artifactDirectory/update-plist.sh "${plistTargetFile}" "BaseUrl" "${5}"
# sh artifactDirectory/update-plist.sh "${plistplistTargetFileFile}" "AppCenterKey" "${5}"
# sh artifactDirectory/update-plist.sh "${plistTargetFile}" "BranchIOKey" "${5}"
# sh artifactDirectory/update-plist.sh "${plistTargetFile}" "GigyaKey" "${5}"
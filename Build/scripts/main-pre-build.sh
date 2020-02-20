#!/bin/bash
# exit if a command fails
set -e

libraryGroupId="${1}"
buildId="${2}"
iosVersionNumber="${3}"
androidVersionNumber="${4}"
plistFile="${5}"
manifestFile="${6}"
outputDirectory="${7}"

accessToken="${8}"
url="${9}"

assetsFolder=$(find . -name "Assets.xcassets" -maxdepth 2)

incrementMajorMinorPatch()
{
	local applicationVersion="${1}"
	local libraryVersion="${2}"

	IFS='.' read -ra app <<< "${applicationVersion}"
	IFS='.' read -ra library <<< "${libraryVersion}"
	local major=${app[0]}
	local minor=${app[0]}
	local patchNumber=0

	if [[ ${app[0]} > ${library[0]} ]]; then
		major=${app[0]}
		minor=${app[1]}
		patchNumber=0
	elif [[ ${app[1]} > ${library[1]} ]]; then
		# compare minor
		major=${library[0]}
		minor=${app[1]}
		patchNumber=0
	else
		# if no change increment patch by one
		major=${library[0]}
		minor=${library[1]}
		local patchNumber=$((${library[2]}+1))
	fi
	echo "${major}.${minor}.${patchNumber}"
}

updateVersion()
{
	local iosVersion="${1}"
	local androidVersion="${2}"
	local plistFile="${3}"
	local manifestFile="${4}"
	local artifactDirectory="${5}"

	iosCurrentVersion="$(sh "${artifactDirectory}/read-write-plist.sh" "${plistFile}" "CFBundleShortVersionString")"
	echo " [i] Current iOS Version: ${iosCurrentVersion}"
	iosNewVersion=$(incrementMajorMinorPatch "${iosCurrentVersion}" "${iosVersion}")
	echo " [i] New iOS Version: ${iosNewVersion}"
	sh "${artifactDirectory}/read-write-plist.sh" "${plistFile}" "CFBundleShortVersionString" "${iosNewVersion}"
	echo
	androidCurrentVersion="$(sh "${artifactDirectory}/read-write-manifest.sh" "${manifestFile}" "android:versionName")"
	echo " [i] Current Android Version: ${androidCurrentVersion}"
	androidNewVersion=$(incrementMajorMinorPatch "${androidCurrentVersion}" "${androidVersion}")
	echo " [i] New Android Version: ${androidNewVersion}"
	sh "${artifactDirectory}/read-write-manifest.sh" "${manifestFile}" "android:versionName" "${androidNewVersion}"
}

updateBuildNumber()
{
	local buildId="${1}"
	local plistFile="${2}"
	local manifestFile="${3}"
	local artifactDirectory="${4}"
	# Update Build Number
	sh "${artifactDirectory}/read-write-plist.sh" "${plistFile}" "CFBundleVersion" "${buildId}"
	sh "${artifactDirectory}/read-write-manifest.sh" "${manifestFile}" "android:versionCode" "${buildId}"
}

updateDevopsLibrary()
{
	local libraryGroupId="${1}"
	local version="${2}"
	local accessToken="${3}"
	local url="${4}"
	echo ${accessToken}
	echo ${url}
	# Update Library in DevOps
	curl -fL -XPUT -H "Authorization:Bearer ${accessToken}" -H "Content-Type:application/json" \
	 -d "{
	   \"id\": \"${libraryGroupId}\",
	   \"type\": \"Vsts\",
	   \"name\": \"BuildDemoVersion\",
	   \"variables\": {
	     \"Library.GroupId\": {
	       \"value\": \"${libraryGroupId}\"
	     },
 	     \"Library.IosVersion\": {
 	       \"value\": \"${iosNewVersion}\"
 	     },
 	     \"Library.AndroidVersion\": {
 	       \"value\": \"${androidNewVersion}\"
 	     }
	   }
	 }" "${url}"
}

# updateDevopsLibraryTest()
# {
# 	local libraryGroupId="${1}"
# 	local iosVersion="${2}"
# 	local androidVersion="${3}"
# 	# Update Library in DevOps
# 	curl -fL -XPUT -H "Authorization:Basic VGVzdDp3ZDdtY2NtaXA2eW16NWoyaXVoY3ZhZWVjemFhYnpwdnZ3anRjZ2V1NnVnemd2YWpocnBx" -H "Content-Type:application/json" \
# 	 -d "{
# 	   \"id\": \"${libraryGroupId}\",
# 	   \"type\": \"Vsts\",
# 	   \"name\": \"TestAppVersion\",
# 	   \"variables\": {
# 	     \"library.groupId\": {
# 	       \"value\": \"${libraryGroupId}\"
# 	     },
# 	     \"library.ios.version\": {
# 	       \"value\": \"${iosNewVersion}\"
# 	     },
# 	     \"library.android.version\": {
# 	       \"value\": \"${androidNewVersion}\"
# 	     }
# 	   }
# 	 }" https://dev.azure.com/roadconeno4//RcNo4/_apis/distributedtask/variablegroups/${libraryGroupId}?api-version=5.0-preview.1
# }

sh "${outputDirectory}/store-ios-icon-assets.sh" "${assetsFolder}" "${plistFile}" "${outputDirectory}"
updateVersion "${iosVersionNumber}" "${androidVersionNumber}" "${plistFile}" "${manifestFile}" "${outputDirectory}"
updateBuildNumber "${buildId}" "${plistFile}" "${manifestFile}" "${outputDirectory}"
updateDevopsLibrary "${libraryGroupId}" "${versionNumber}" "${accessToken}" "${url}"
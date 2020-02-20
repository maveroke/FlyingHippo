#!/bin/bash
# exit if a command fails
set -e

directory="${1}"
version="${2}"
solution="$(find "${directory}" -name "*.sln")"
BUILD_NUMBER=2
LIBRARY_GROUPID="8"
certificate="iPhone Developer: michael whitehead (KK544KLPG8)" # must be in keychain
provisioningProfile="/Users/m/.apple/wildCardProfile.mobileprovision"
outputDirectory="artifactDirectory"
scriptDir="$(dirname $0)"

keystoreFile="/Users/m/Library/Developer/Xamarin/Keystore/roadconeno4/roadconeno4.keystore"
keystorePassword="y27bvla6"
keystoreAlias="roadconeno4"
csprojFile="$(find "${directory}/BuildDemo.Android" -name "*.csproj")"
manifestTargetFile="${directory}/BuildDemo.Android/Properties/AndroidManifest.xml"
# //TODO: Mikel 
# Remove tmp dir
# Fix pre-build.sh to target non test methods
# Check we increment this files version at the end

# create tmp directory
mkdir -p "${outputDirectory}"
# copy all scripts to tmp
cp -a Build/build/*.sh "${outputDirectory}"
cp -a Build/tasks/*.sh "${outputDirectory}"
# remove at the end

# ============ prebuild ============
# ==================================
sh "artifactDirectory/pre-build.sh" "${BUILD_NUMBER}" "${LIBRARY_GROUPID}" "${version}" "${version}" "${outputDirectory}"


# clean all
find "${directory}" -iname "bin" -o -iname "obj" -o -iname "packages" -mindepth 0 | xargs -n 1 echo
find "${directory}" -iname "bin" -o -iname "obj" -o -iname "packages" -mindepth 0 | xargs rm -rf

# nuget restore
nuget restore -Verbosity quiet "${solution}"

# # run unit tests
# dotnet test "$csprojFile" --no-build --no-restore --configuration $config

# build ios
msbuild "$solution" /p:Configuration="Release" /p:Platform="iPhone" /p:ArchiveOnBuild="true" /p:BuildIpa="true"

iosBin="${directory}/BuildDemo.iOS/bin"
ipaFile="$(find "${iosBin}" -name "*.ipa")"

# ========= post-build ios =========
# ==================================
sh artifactDirectory/post-build.sh "${ipaFile}" "${outputDirectory}" "${certificate}" "${provisioningProfile}"


# ========= build  android =========
# ==================================
sh artifactDirectory/android-build.sh "${keystoreFile}" "${keystorePassword}" "${keystoreAlias}" "${csprojFile}" "${manifestTargetFile}" "${outputDirectory}"


# ============ clean up ============
# ==================================
# rm -rf "${outputDirectory}"
rm artifactDirectory/*.sh
# increment build number
sed -i '' "s|^BUILD_NUMBER=.*|BUILD_NUMBER=${BUILD_NUMBER}|" $0

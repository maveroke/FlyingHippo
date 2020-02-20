#!/bin/bash
# exit if a command fails
set -e

# target plist
# target appIcon
outputDirectory="${1}"
appIcon="${2}"

if [ -z "${outputDirectory}" ] ; then
	echo " [!] No target directory specified."
	exit 1
fi

if [ -z "${appIcon}" ] ; then
	echo " [!] No AppIcon specified."
	exit 1
fi

# Find specified AppIcon folder
assetsTarget="$(find "${outputDirectory}/actools" -type d -name "${appIcon}" -print -quit)"
if [[ ! -d "${assetsTarget}" ]]; then
	echo " [!] No AppIcon matching \"${appIcon}\" found."
	exit 1
fi

app="$(find "${outputDirectory}" -name "*.app" -print -quit)"
# Replace Assets.car in .app folder
cp "${assetsTarget}/Assets.car" "${app}/Assets.car"

# Delete old icons
appIconFiles="$(/usr/libexec/PlistBuddy -c "Print :CFBundleIcons:CFBundlePrimaryIcon:CFBundleIconFiles" "${app}/Info.plist")"
echo $appIconFiles

for appIconFile in $appIconFiles; do
	if [[ $appIconFile != "Array" && $appIconFile != "{" && $appIconFile != "}" ]]; then
		icons="$(find "${app}" -name "${appIconFile}*" -print)"
		for icon in $icons; do
			echo " [i] removing: ${icon}"
			rm -rf "${icon}"
		done
	fi
done

ls "${app}"

# Delete AppIcon from .app plist
/usr/libexec/PlistBuddy -x -c "Delete CFBundleIcons" "${app}/Info.plist"

# Merge AppIcon plist file into .app plist file
/usr/libexec/PlistBuddy -x -c "Merge ${assetsTarget}/Info.plist" "${app}/Info.plist"

# Copy .png files into .app (replaceing old icons)
newIconFiles="$(find "${assetsTarget}" -name "*.png" -print)"
for newIconFile in $newIconFiles; do
	echo $newIconFile
	cp "${newIconFile}" "${app}/"
done
#!/bin/bash
# exit if a command fails
set -e

application="${1}"
developerDirectory=`xcode-select --print-path`

if [ -z "${application}" ] ; then
	echo " [!] No target application (.app) specified."
	exit 1
fi


echo " [i] Application: ${application}"
echo " [i] xcode Directory: ${developerDirectory}"

rm -r "${application}/SwiftFrameworksSimulator"
rm -r "${application}../SwiftSupport/iphoneos"

echo "+ Adding SWIFT support (if necessary)"
for swiftLibrary in $(find "${app}/Frameworks" -name "*.dylib" ); do
	libraryName=$(basename "${swiftLibrary}")
    echo " [i] Copying ${libraryName}"
    cp -f "${developerDirectory}/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift-5.0/iphoneos/${libraryName}" "${tmpDir}/SwiftSupport"
    lipo -thin arm64 "${tmpDir}/SwiftSupport/${libraryName}" -o "${tmpDir}/SwiftSupport/${libraryName}"
    cp -f "${tmpDir}/SwiftSupport/${libraryName}" "${swiftLibrary}"
done

rm -rf SwiftSupport
#!/bin/bash

BUILD_NUMBER=$1
DIRECTORIES=$2
FILES=$3
BUILD_ROOT="${HOME}/android_build"
DEVICE_VENDOR="samsung"
DEVICE_NAME="captivate"
DEVICE_DIR="${BUILD_ROOT}/device/${DEVICE_VENDOR}/${DEVICE_NAME}"
OUTPUT_FILE="${DEVICE_DIR}/extract-files${BUILD_NUMBER}.sh"

display_usage () {
	printf "Usage: $0 <build number> <directories list> <files list>\n";
	printf "Example: $0 6 ./files.txt ./directories.txt\n";
}

test_exit_code() {
	if [ "$1" -eq "0" ]; then
		printf "Done\n"
	else
		printf "Failed\n"
		exit 1
	fi
}

if [ $# -ne 3 ]; then
	display_usage
	exit
fi

if [ ! -d "${DEVICE_DIR}" ]; then
	printf "Creating ${DEVICE_DIR}..."
	mkdir -p "${DEVICE_DIR}" > /dev/null 2>&1
	test_exit_code $?
fi

echo "Using directories in ${DIRECTORIES}"
echo "Using files in ${FILES}"
echo "Generating ${OUTPUT_FILE}"

(cat << EOF) > ${OUTPUT_FILE}
#!/bin/sh

# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

EOF

echo "DEVICE=${DEVICE_NAME}" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "mkdir -p ../../../vendor/samsung/\$DEVICE/proprietary" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "DIRS=\"" >> ${OUTPUT_FILE}

while read LINE; do
	echo ${LINE} >> ${OUTPUT_FILE}
done < ${DIRECTORIES}

echo "\"" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "for DIR in \$DIRS; do" >> ${OUTPUT_FILE}
printf "\tmkdir -p ../../../vendor/samsung/\$DEVICE/proprietary/\$DIR\n" >> ${OUTPUT_FILE}
echo "done" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "FILES=\"" >> ${OUTPUT_FILE}

while read LINE; do
	echo ${LINE} >> ${OUTPUT_FILE}
done < ${FILES}

echo "\"" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "for FILE in \$FILES; do" >> ${OUTPUT_FILE}
printf "\t adb pull \$FILE ../../../vendor/${DEVICE_VENDOR}/\$DEVICE/proprietary/\$FILE\n" >> ${OUTPUT_FILE}
echo "done" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}
echo "(cat << EOF) | sed s/__DEVICE__/\$DEVICE/g > ../../../vendor/samsung/\$DEVICE/\$DEVICE-vendor-blobs.mk" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}
echo "PRODUCT_COPY_FILES := \\\\" >> ${OUTPUT_FILE}
echo "    vendor/samsung/__DEVICE__/proprietary/lib/libgps.so:obj/lib/libgps.so \\\\" >> ${OUTPUT_FILE}
echo "    vendor/samsung/__DEVICE__/proprietary/lib/libsecgps.so:obj/lib/libsecgps.so \\\\" >> ${OUTPUT_FILE}
echo "    vendor/samsung/__DEVICE__/proprietary/lib/libsecril-client.so:obj/lib/libsecril-client.so" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}

echo "PRODUCT_COPY_FILES += \\\\" >> ${OUTPUT_FILE}
while read LINE; do
	echo "    vendor/samsung/__DEVICE__/proprietary/$LINE:system/$LINE \\\\" >> ${OUTPUT_FILE}
done < ${FILES}
echo "EOF" >> ${OUTPUT_FILE}
echo >> ${OUTPUT_FILE}
echo "./setup-makefiles.sh" >> ${OUTPUT_FILE}

chmod 755 ${OUTPUT_FILE}
echo "Complete! Keep in mind that ${OUTPUT_FILE} has not been organized and should only be used for testing. Once you have a usable extract-file.sh you should organize the files appropriately."

#!/usr/bin/env bash

# Copyright 2017 Vincent Damewood
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. ./config/config.sh

SIGN_CONF=${CONF_DIR}/sign.cnf
REQ_TEMPLATE=${CONF_DIR}/req.tpl

if [ "$#" -ge 1 ]; then
	HOST=$1
else
	echo "Usage: mkcert.sh hostname [alias] ..."
fi

KEY_DIR=${KEYS_DIR}/${HOST}
KEY_FILE=${KEY_DIR}/${HOST}.key
CERT_FILE=${KEY_DIR}/${HOST}.crt

REQ_CONF=`mktemp -t ${HOST}.cnf`
if [ $? -ne 0 ]; then
	echo "Failed to make temporary config file."
	exit 1
fi

REQ_FILE=`mktemp -t ${HOST}.req`
if [ $? -ne 0 ]; then
	echo "Failed to make temporary certificate signing request file."
	exit 1
fi

cat ${REQ_TEMPLATE} > ${REQ_CONF}
printf "commonName = %s\n\n[ subject_alt_names ]\n" \
	"${HOST}.${DOMAIN}" >> ${REQ_CONF}

DNS_COUNT=1
IP_COUNT=1
while [ "$#" -gt 0 ]; do
	# FIXME: Determine if $1 is an IP address.
	if false; then
		printf "IP.%s = %s\n" "${IP_COUNT}" "${1}" >> ${REQ_CONF}
		IP_COUNT=$[$IP_COUNT+1]
		shift
	else
		printf "DNS.%s = %s\n" "${DNS_COUNT}" "${1}.${DOMAIN}" >> ${REQ_CONF}
		DNS_COUNT=$[$DNS_COUNT+1]
		printf "DNS.%s = %s\n" "${DNS_COUNT}" "${1}" >> ${REQ_CONF}
		DNS_COUNT=$[$DNS_COUNT+1]
		shift
	fi
done

#######################################
##### Begin Actual Key Generation #####
#######################################

mkdir -p ${KEY_DIR}

# Generate Hosts's Private Key if none exists.
if [ ! -s ${KEY_FILE} ]; then
	${OPENSSL} genrsa \
		-out ${KEY_FILE} 2048
fi
chmod 400 ${KEY_FILE}

# Generate Certificate Signing Request
${OPENSSL} req \
	-new \
	-key ${KEY_FILE} \
	-out ${REQ_FILE} \
	-config ${REQ_CONF}


# If there's already a certificate, save it.
if [ -s ${CERT_FILE} ]; then
	SUFFIX=1
	while [ -s ${CERT_FILE}.${SUFFIX} ]; do
		SUFFIX=$[$SUFFIX + 1]
	done
	mv ${CERT_FILE} ${CERT_FILE}.${SUFFIX}
fi


# Create certificate
${OPENSSL} ca \
	-batch -notext \
	-in ${REQ_FILE} \
	-out ${CERT_FILE} \
	-config ${SIGN_CONF}
chmod 444 ${CERT_FILE}
rm -f ${REQ_FILE} ${REQ_CONF}

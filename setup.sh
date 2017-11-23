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

. ./include/config.sh


if [ "$#" -ne 5 ]; then
	echo "usage: setup.sh <Country> <StateOrProvince> <Locality> <Organization> <CA Common Name>"
	echo " -- Country: Two-leter country code"
	echo " -- StateOrProvince: State, Province, or other administrative division"
	echo " -- Locality: City, Town, or other smaller administrative division"
	echo " -- Organization: The Name of the entity controlling the certificate authority"
	echo " -- CA Common Name: A Unique name identifying the certificate authority"
	exit 1
fi

CONF_TEMPLATE=${TEMPLATE_DIR}/ca.cnf
REQ_CONF_TEMPLATE=${TEMPLATE_DIR}/req.cnf
CONF_FILE=${CONF_DIR}/ca.cnf
REQ_CONF_FILE=${CONF_DIR}/req.cnf

mkdir -p ${CA_DIR} ${DATA_DIR} ${KEYS_DIR} ${CA_CERT_DIR}

cp ${CONF_TEMPLATE} ${CONF_FILE}
printf "countryName = %s\n" "${1}" >> ${CONF_FILE}
printf "stateOrProvinceName = %s\n" "${2}" >> ${CONF_FILE}
printf "localityName = %s\n" "${3}" >> ${CONF_FILE}
printf "organizationName = %s\n" "${4}" >> ${CONF_FILE}
printf "commonName = %s\n" "${5}" >> ${CONF_FILE}

cp ${REQ_CONF_TEMPLATE} ${REQ_CONF_FILE}
printf "countryName = %s\n" "${1}" >> ${REQ_CONF_FILE}
printf "stateOrProvinceName = %s\n" "${2}" >> ${REQ_CONF_FILE}
printf "localityName = %s\n" "${3}" >> ${REQ_CONF_FILE}
printf "organizationName = %s\n" "${4}" >> ${REQ_CONF_FILE}


touch ${DATABASE_FILE}
echo 1000 > ${SERIAL_FILE}

# Create Root Key:
${OPENSSL} genrsa -out ${CA_KEY} 4096
chmod 400 ${CA_KEY}

# Create Root Certificate:
${OPENSSL} req \
	-new \
	-x509 -days 3652 \
	-key ${CA_KEY} \
	-out ${CA_CRT} \
	-config ${CONF_FILE}
chmod 444 ${CA_CRT}

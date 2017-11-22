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

CONF_FILE=${CONF_DIR}/ca.cnf

mkdir -p ${CA_DIR} ${DATA_DIR} ${KEYS_DIR} ${CA_CERT_DIR}
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

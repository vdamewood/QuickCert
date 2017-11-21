OPENSSL=openssl
DOMAIN=localdomain

BASE_DIR=.
KEYS_DIR=${BASE_DIR}/keys
CONF_DIR=${BASE_DIR}/config

CA_DIR=${BASE_DIR}/ca
CA_KEY=${CA_DIR}/ca.key
CA_CRT=${CA_DIR}/ca.crt
CA_CERT_DIR=${CA_DIR}/certs

DATA_DIR=${CA_DIR}/data
DATABASE_FILE=${DATA_DIR}/database
SERIAL_FILE=${DATA_DIR}/serial

if [ -s include/local.sh ]; then
	. include/local.sh
fi

if [ -z "${OPENSSL}" ]; then
	OPENSSL=openssl
fi

if [ -z "${DOMAIN}" ]; then
	DOMAIN=localdomain
fi

if [ -z "${BASE_DIR}" ]; then
	BASE_DIR=.
fi

KEYS_DIR=${BASE_DIR}/keys
CONF_DIR=${BASE_DIR}/config
TEMPLATE_DIR=${BASE_DIR}/templates

CA_DIR=${BASE_DIR}/ca
CA_KEY=${CA_DIR}/ca.key
CA_CRT=${CA_DIR}/ca.crt
CA_CERT_DIR=${CA_DIR}/certs

DATA_DIR=${CA_DIR}/data
DATABASE_FILE=${DATA_DIR}/database
SERIAL_FILE=${DATA_DIR}/serial

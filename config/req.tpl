[ req ]
default_bits           = 2048
distinguished_name     = distinguished_name
string_mask            = utf8only
default_md             = sha256
prompt                 = no
req_extensions         = extensions

[ extensions ]
keyUsage               = critical, digitalSignature, keyEncipherment
extendedKeyUsage       = serverAuth
subjectAltName         = @subject_alt_names

[ distinguished_name ]
countryName             =
stateOrProvinceName     =
localityName            =
organizationName        =

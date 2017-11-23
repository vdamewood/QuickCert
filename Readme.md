# QuickCert

QuickCert is a set of shell scripts for automating the process of
setting up a private, testing SSL certificate authority. Mostly, it's a
quick and dirty way to get rid of warnings about unsecured connections
and self-signed certificates. QuickCert is licensed under the terms of
the Apache License version 2.0. See the file License.txt for details.

There are two scripts:

* `setup.sh` -- Generates the files needed for a private certificate
	authority including a private key, a self-signed certificate, a
	blank database of certificates, and a serial number file.
* `mkcert.sh` -- Generates a private key and a matching certificate
	signed by the certificate authority generated with `setup.sh`.

## Setup

Before setting up QuickCert, you may want to edit the file
`include/config.sh`. The `config.sh` file has an `OPENSSL`
variable and a `DOMAIN` variable. The defaults values should be
functional. If you wish to change the values, set `OPENSSL` to the
location of the OpenSSL or LibreSSL executable you would like to use.
Set the `DOMAIN` variable to  your own domain. The `mkcert.sh` script
will automatically append this to any names you pass to it.

To set up QuickCert, run the `setup.sh` script with your your country
(as a two-letter code), state/province/region, city/town,
organization name, and a unique name for your certificate authority, in
order, as arguments. For example:

```
./mkcert.sh US Oregon Portland "Fake Web Services" "Fake Web Services CA"
```

This will copy the files from the `templates` directory into the
`config` directory, add your identifying information to the copies in
the `config` directory. and generate the key and certificate for
your certificate authority. To get web browsers to trust your
certificate authority, you will have to import the file `./ca/ca.crt`
after it has been generated. This process varies between browsers.

## Generating Certificates

To generate a certificate, run the `mkcert.sh` script in the base
directory with one or more arguments. The first argument, augmented
with the `DOMAIN` value in `config/config.sh` will become the the
common name value for the certificate. All of the arguments, both
augmented with the `DOMAIN` value and without, will be used as subject
alternative names for the generated certificate. Once generated, the
files `./keys/<commonName>.key` and `./certs/<commonName>.crt` can be
used with your web server. The exact process for installing keys and
certificates varies.

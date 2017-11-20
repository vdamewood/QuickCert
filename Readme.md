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

To setup QuickCert, edit the files in the `config` directory with your
own identifying information. The fields in the `distinguished_name`
section in the `ca.cnf` and `req.tpl` files must match, and the
`req.tpl` file must _not_ have a `commonName` field. (It will added by
the `mkcert.sh` script.) The `config.sh` script has an `OPENSSL`
variable and a `DOMAIN` variable. set `OPENSSL` to the location of the
OpenSSL or LibreSSL executable you would like to use, if you wish to us
a custom build. Set the `DOMAIN` variable to  your own domain. The
`mkcert.sh` script will automatically append this to any names you pass
to it.

Once you have edited the configuration files, run `setup.sh` in the base
directory of the project. It will generate the key and certificate for
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
files `./keys/<commonName>.key` and `./certs/<commonNam>.crt` can be
used with your web server. The exact process for installing keys and
certificates varies.

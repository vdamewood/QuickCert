# QuickCert

QuickCert is a set of shell scripts for automating the process of setting up a private, testing SSL certificate authority. Mostly, it's a quick and dirty way to get rid of warnings about unsecured connections and self-signed certificates. QuickCert is licensed under the terms of the Apache License version 2.0. See the file License.txt for details.

There are two scripts:

* setup.sh -- Generates the files needed for a private certificate authority includinga private key, a self-signed certificate, a blank database of signed certificates, and a serial number file.
* mkcert.sh -- Generates a private key and a public certificate for the private key, signed by the certificate authority generated with setup.sh.

# Setup

To setup QuickCert, Edit the files in the config directory with your own identifying information. The `distinguished_name` section in the ca.cnf and req.tpl files must match, and the req.tpl file must _not_ have a commonName field. (It's added by the mkcert.sh script.) The config.sh script has an `OPENSSL` variable and a `DOMAIN` variable. set `OPENSSL` to the location of the OpenSSL or LibreSSL executable you would like to use, if you wish to use a custom build. Set the `DOMAIN` variable to your own domain if you wish to use one.

Once you have edited the configuration fils, run setup.sh in the base directory of the project. It will generate the key and certificate for your certificate authority. To get web browsers to trust your certificate, you will have to import the file ./ca/ca.crt after it is generated. This process varies from browser to browser.

# Generating Signed Certificates

To generate a certificate, run mkcert.sh in the base directory with any number of arguments. The first argument will become the the commonName value for the certificate. All of the arguments will be used as subject alternative names for the generated certificate. After generated, the file `./keys/<commonName>.key` and `./certs/<commonNam>.crt` can be used with your web server. The exact process for installing certificates varies.

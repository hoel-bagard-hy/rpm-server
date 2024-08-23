# SSL certificate

This is a short explanation on how to generate the SSL certificate for the RPM's server (to allow the use of HTTPS).

See [this](https://github.com/hoel-bagard-hy/pypi-repository/blob/master/docs/nginx.md) for more detailed instructions, including how to first generate the CA.

### RPM certificate

First generate a private key for the devpi server's certificate:

```console
openssl genrsa -passout pass:$(pass show ssl/rpm-key-password) -out cert-key.pem 4096
```

Then a create a Certificate Signing Request (CSR)

```console
openssl req -new -sha256 -subj "/C=JP/O=HitachiHighTech/CN=Hoel Bagard/emailAddress=hoel.bagard.hy@hitachi-hightech.com" -key cert-key.pem -out cert.csr
```

Put the serial number tracking and key into files (temporarily).

```console
pass show ssl/ca.srl >> ca.srl
pass show ssl/ca-key.pem >> ca-key.pem
```

And finally create the devpi certificate:

```bash
openssl x509 \
  -req \
  -sha256 \
  -days 3650 \
  -in cert.csr \
  -CA assets/ca.pem \
  -CAkey ca-key.pem \
  -out assets/rpm-cert.pem \
  -subj "/C=JP/O=HitachiHighTech/CN=Hoel Bagard/emailAddress=hoel.bagard.hy@hitachi-hightech.com" \
  -extfile <(printf "subjectAltName=IP:163.219.218.169") \
  -passin pass:$(pass show ssl/ca-key-password) \
  -CAserial ca.srl
```

And finally cleanup:

```console
rm cert.csr
rm ca-key.pem
```

For the serial number, paste it into pass:

```console
cat ca.srl
pass edit ssl/ca.srl
rm ca.srl
```

And same thing for the RPM certificate's key:

```console
cat cert-key.pem
pass edit ssl/rpm-cert-key.pem
rm cert-key.pem
```

# Private RPM Repository

> [!IMPORTANT]
> This repository is simply notes I took for myself (Hoel). While it might be useful to some, it isn't meant to be usable by someone other than me.

## Index

- [References](#references)
- [Setup](#pypi-repository-maintenance)
- [Maintenance](#pypi-repository-maintenance)
- [Usage](#usage)

## References

https://github.com/ai-platform-metis/Metis_PackageRepo/tree/main/rpm

## RPM repository server setup

### Build the docker

```bash
docker build \
    -t hoel/rpm-repository \
    --build-arg PROXY_USERNAME="$(pass show admin_proxy_username)" \
    --build-arg PROXY_PASSWORD="$(pass show admin_proxy_password)" \
    --build-arg SSL_CERT_KEY="$(pass show ssl/devpi-cert-key.pem)" \
    .
```

### Start the server

Running the docker will create the server if required, then start it. The server's data will be stored in the passed volume (here `/home/devpi`).\
You can then access it at `http://localhost:3141/` (if doing this on a server, to access it on your laptop you can create an ssh tunnel).

```bash
docker run \
    -dt \
    --rm \
    --env HTTP_PROXY=$HTTP_PROXY \
    --env http_proxy=$http_proxy \
    --env https_proxy=$https_proxy \
    --env HTTPS_PROXY=$HTTPS_PROXY \
    --name rpm-repository \
    -v /home/rpm:/data/packages \
    -p 555:555 \
    hoel/rpm-repository
```

## Usage

### Adding an RPM package

### Installing a package from the private repository

## TODO

- Make the server automatically restart, and make it start on boot.

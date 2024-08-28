# Private RPM Repository

> [!IMPORTANT]
> This repository is simply notes I took for myself (Hoel). While it might be useful to some, it isn't meant to be usable by someone other than me.

## Index

- [References](#references)
- [Setup](#rpm-repository-server-setup)
- [Usage](#usage)
- [Test](#test)

## References

The private repository was originally populated with packages from [this repo](https://github.com/ai-platform-metis/Metis_PackageRepo/tree/main/rpm).

## RPM repository server setup

### Build the docker

```bash
docker build \
    -t hoel/rpm-repository \
    --build-arg PROXY_USERNAME="$(pass show admin_proxy_username)" \
    --build-arg PROXY_PASSWORD="$(pass show admin_proxy_password)" \
    --build-arg SSL_CERT_KEY="$(pass show ssl/rpm-cert-key.pem)" \
    .
```

### Start the server

Running the docker will create the server if required, then start it. The server's data (rpm files) is expected to be stored in the passed volume (here `/home/rpm`).\
You can then browse the repository at `http://<server ip>:3214/` if browsing from a server. If browsing from your laptop you can create an ssh tunnel with `ssh -fN -L 13214:localhost:3214 rocky.hht` and then go to `http://localhost:13214/`.

The current configuration only supports/expects one repository. The expected file structure is:

```
/home/rpm/el7-x86_64/
├── bzip2-devel-1.0.6-13.el7.x86_64.rpm
├── centos-release-scl-2-3.el7.centos.noarch.rpm
├── centos-release-scl-rh-2-3.el7.centos.noarch.rpm
├── ...
└── zlib-devel-1.2.7-18.el7.x86_64.rpm
```

To start the server, use the following command.

```bash
docker run \
    -dt \
    --rm \
    --name rpm-repository \
    -v /home/rpm:/data/packages \
    -p 3214:3214 \
    -p 515:515 \
    hoel/rpm-repository
```

<details>
<summary>Proxy</summary>

The proxy is not necessary for the server to operate. However it can be set by adding the following arguments to the command above. This can be necessary when debugging.

```bash
    --env HTTP_PROXY=$HTTP_PROXY \
    --env http_proxy=$http_proxy \
    --env https_proxy=$https_proxy \
    --env HTTPS_PROXY=$HTTPS_PROXY \
```

</details>

## Usage

See [the user manual](./docs/user-manual.md).

## Test

You can test that the repository is usable by using the `Dockerfile` in [the tests folder](./tests/).\
Since it is better to do the tests from another server (just in case), and that some servers do not have a properly configured DNS, you maybe need to pass in the proxy's IP address when building the docker:

```bash
docker build \
    -t hoel/rpm-test \
    --build-arg PROXY_IP=158.213.204.80 \
    --build-arg PROXY_USERNAME="$(pass show admin_proxy_username)" \
    --build-arg PROXY_PASSWORD="$(pass show admin_proxy_password)" \
    tests
```

You can then run the docker and try to install packages as described in [the user manual](./docs/user-manual.md).

```console
docker run -it hoel/rpm-test
```

## TODO

- Make the server automatically restart, and make it start on boot.
- Ideally we would want to use subdomains instead of ports (nginx). However that requires a DNS so...

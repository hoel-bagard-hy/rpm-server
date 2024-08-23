# Private RPM Repository

> [!IMPORTANT]
> This repository is simply notes I took for myself (Hoel). While it might be useful to some, it isn't meant to be usable by someone other than me.

## Index

- [References](#references)
- [Setup](#pypi-repository-maintenance)
- [Maintenance](#pypi-repository-maintenance)
- [Usage](#usage)

## References

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
    -it \
    --rm \
    --env HTTP_PROXY=$HTTP_PROXY \
    --env http_proxy=$http_proxy \
    --env https_proxy=$https_proxy \
    --env HTTPS_PROXY=$HTTPS_PROXY \
    --name rpm-repository \
    hoel/rpm-repository
```

    -p 3141:3141 \
    -p 80:80 \
    -p 443:443 \
    -dt \
    -v /home/rpm:/data \

<details>
<summary>Port notes</summary>

- 3141 is the default devpi port.
- 80 is default http port.
- 443 is default https port.

</details>

And then do the initial set-up using:

```console
docker exec -it pypi-repository devpi-client bash
/scripts/initial_setup.sh
```

## PyPI repository maintenance

### Accessing the docker

You can execute devpi command using the `devpi-client` script in the docker. It will execute the commands using the root user.

```console
docker exec -it pypi-repository devpi-client -h
```

For example creating a new user:

```console
docker exec -it pypi-repository devpi-client user -c hoel password=$(pass show devpi-hoel)
```

You can also start an interactive shell with:

```console
docker exec -it pypi-repository devpi-client bash
```

And from the shell, for example, allow all users to upload to the `shared/release` index.

```console
devpi user -l | tr "\\n" "," | xargs -i devpi index shared/release 'acl_upload={}'
```

### Whitelist

The whitelist is is managed using the [devpi-constrained package](https://github.com/devpi/devpi-constrained?tab=readme-ov-file#usage), see the documentation there.

## Usage

See [the user manual](./docs/user-manual.md).

## TODO

- Make the server automatically restart, and make it start on boot.
  - For the restart part, assuming the docker doesn't die, go back to generating configs, then use the `devpi.service`.

## Notes

[tag:proxy]\
The proxy needs to be set for the shell running the server (for it to be able to access PyPI), hence the `--env` in the `docker run` command.
However it cannot be set when using `devpi` commands (no idea why, I tried to set the Waitress trusted proxy without success).

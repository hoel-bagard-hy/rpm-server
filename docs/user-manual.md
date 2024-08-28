# User manual

## Index

- [Repositories](#repositories)
- [General instructions](#general-instructions)
  - [Proxy](#proxy)
  - [Access](#access)
- [Adding a package](#adding-an-rpm-package)
- [Installing a package](#installing-a-package-from-the-private-repository)

## Repositories

The RPM server currently holds only one repository (`el7-x86_64/`), which can be accessed at `163.219.218.169:514`.

## General instructions

### Proxy

The private RPM server is located on HHT servers (in Harumi), to access it you must therefore satisfy the following two conditions:

- Be connected to the local network, either by being in Harumi, or by using the GlobalProtect VPN.
- Have no environment variable proxy settings set (most notably `http_proxy`). If they are already set, you can prepend `http_proxy= ` to your command.
  For example: `http_proxy= yum --disablerepo="*" --enablerepo="hht" install <package name>`

### Access

The server can be accessed at `163.219.218.169`, with port `514` for HTTP and `515` for HTTPS.\
The address is used when downloading/uploading packages, but can also be used to browse the packages in a web browser ([HTTP link](http://163.219.218.169:514/), [HTTPS link](https://163.219.218.169:515/)).

Note: the 515 port is currently not in the list of open ports, therefore the HTTPS version can only be accessed from the Harumi servers. If you wish to access it from your laptop, you will need to use port forwarding.

## Adding an RPM package

To add a package, simply add the `.rpm` file to the folder containing the `.rpm` files. For example:

```console
scp openssl-1.0.2k-19.el7.x86_64.rpm 163.219.218.169:/home/rpm/el7-x86_64/
```

## Installing a package from the private repository

### First time setup

On client machines, configure YUM to use the private repository by running the following command:

```bash
sudo echo "[hht]
name=Hitachi High Tech Private Repo
baseurl=http://163.219.218.169:514
enabled=1
gpgcheck=0" >> /etc/yum.repos.d/hht.repo
```

### Installing a package

To install a package from the private repository, first make sure that the proxy is not set. This means removing it from `/etc/yum.conf` and un-setting the `http_proxy` environment variable. \
Then disable all the repositories except the HHT one. For example:

```console
yum --disablerepo="*" --enablerepo="hht" install openssl-1.0.2k-19.el7.x86_64
```

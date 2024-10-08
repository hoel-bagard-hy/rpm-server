# User manual

## Index

- [Repositories](#repositories)
- [General instructions](#general-instructions)
  - [Proxy](#proxy)
  - [Access](#access)
- [Adding a package](#adding-an-rpm-package)
- [Installing a package](#installing-a-package-from-the-private-repository)

## Repositories

The RPM server currently holds 4 repositories, which can be accessed at `163.219.218.169:3214`. The 4 repositories are separated into two categories 認可済みOSS ("approved") and 認可準備中OSS ("approval-pending"), leading to the following file structure:

```
163.219.218.169:3214/
├── approved/
│   ├── el7-x86_64
│   └── el9-x86_64
└── approval-pending/
    ├── el7-x86_64
    └── el9-x86_64
```

## General instructions

### Proxy

The private RPM server is located on HHT servers (in Harumi), to access it you must therefore satisfy the following two conditions:

- Be connected to the local network, either by being in Harumi, or by using the GlobalProtect VPN.
- Have no environment variable proxy settings set (most notably `http_proxy`). If they are already set, you can prepend `http_proxy= ` to your command.
  For example: `http_proxy= yum --disablerepo="*" --enablerepo="hht" install <package name>`

### Access

The server can be accessed at `163.219.218.169`, with port `3214` for HTTP and `3215` for HTTPS.\
The address is used when downloading/uploading packages, but can also be used to browse the packages in a web browser ([HTTP link](http://163.219.218.169:3214/), [HTTPS link](https://163.219.218.169:3215/)).

## Adding an RPM package

To add a package, simply add the `.rpm` file to the folder containing the `.rpm` files. For example:

```console
scp openssl-1.0.2k-19.el7.x86_64.rpm 163.219.218.169:/home/rpm/approval-pending/el7-x86_64/
```

Then update the repo's metadata with:

```bash
ssh -t 163.219.218.169 'createrepo --update /home/rpm/approval-pending/el7-x86_64/'
```

## Installing a package from the private repository

### First time setup

On client machines, configure YUM to use the private repository by running the following command:

```bash
sudo echo "[hht]
name=Hitachi High Tech Private Repo
baseurl=http://163.219.218.169:3214/approved/el7-x86_64/
enabled=1
gpgcheck=0" >> /etc/yum.repos.d/hht.repo
```

You can also add the `approval-pending` and/or `el9` repos in a similar fashion.

### Installing a package

To install a package from the private repository, first make sure that the proxy is not set. This means removing it from `/etc/yum.conf` and un-setting the `http_proxy` environment variable. \
Then disable all the repositories except the HHT one. For example:

```console
yum --disablerepo="*" --enablerepo="hht" install openssl-1.0.2k-19.el7.x86_64
```

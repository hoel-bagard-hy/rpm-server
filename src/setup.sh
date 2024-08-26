#!/usr/bin/env bash

# The actual setup was done by entering the commands manually, but this script should still be useful in
# case a re-setup is necessary.

# Create a folder where the binaries/repo data will be stored. We could use a volume, but that way is slightly more convenient imho.
mkdir /home/rpm
# Initialise the repo with the binaries from the GitHub repo.
cpr Metis_PackageRepo/rpm/el7-x86_64 /home/rpm
# Remove the non-binary files.
rm -r /home/rpm/el7-x86_64/repodata /home/rpm/el7-x86_64/Metis.repo
# That one file has different permissions from the rest, fix it.
chmod +x /home/rpm/util-linux-2.23.2-61.el7_7.1.x86_64.rpm

# The actual setup was done by entering the commands manually, but this script should still be useful in
# case a re-setup is necessary.

# First add the binaries from outside the docker.
mkdir /home/rpm
cpr Metis_PackageRepo/rpm/el7-x86_64 /home/rpm
rm -r /home/rpm/el7-x86_64/repodata /home/rpm/el7-x86_64/Metis.repo

# Then set-up the server from inside the docker.
createrepo /data/packages/el7-x86_64/

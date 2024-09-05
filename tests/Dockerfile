FROM rockylinux:9.3

# The PROXY_IP can either be obprx.intra.hitachi.co.jp or 158.213.204.80.
# This is to allow using the image even on servers where the DNS is not working properly.
ARG PROXY_IP
ARG PROXY_USERNAME
ARG PROXY_PASSWORD

# Add the Hitachi certificate
COPY assets/Cisco_Umbrella_Root_CA.cer /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust

# Set the dnf/yum proxy to be able to install packages.
RUN echo "proxy=$PROXY_IP:8080" >> /etc/dnf/dnf.conf && \
    echo "proxy_username=$PROXY_USERNAME" >> /etc/dnf/dnf.conf && \
    echo "proxy_password=$PROXY_PASSWORD" >> /etc/dnf/dnf.conf

# Install packages that are useful when testing things.
# Do not pin the versions below, since this prevents installing security updates and (ironically) prevents reproducibility.
# hadolint ignore=DL3041
RUN dnf install -y vim-enhanced wget && \
    dnf clean all

# Reset the dnf/yum config so since it is not possible to use the internal rpm repo and the proxy simultaneously.
COPY assets/default_dnf.conf /etc/dnf/dnf.conf

# Add the internal rpm repo.
COPY assets/hht.repo /etc/yum.repos.d/hht.repo

CMD ["bash"]

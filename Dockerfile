# Do not use ubuntu/debian/etc..., since we need the createrepo package.
# Do not use CentOS (centos:centos8.4.2105, etc...) because it is a massive pain in the ***
# Do not use the minimal version of rocky linux, since it is indeed very minimal (no dnf/yum)
FROM rockylinux:9.3

ARG SSL_CERT_KEY
ARG PROXY_USERNAME
ARG PROXY_PASSWORD

# Set the proxy
COPY src/dnf.conf /etc/dnf/dnf.conf
RUN echo "proxy_username=$PROXY_USERNAME" >> /etc/dnf/dnf.conf && \
    echo "proxy_password=$PROXY_PASSWORD" >> /etc/dnf/dnf.conf

# Add the Hitachi certificate
COPY assets/Cisco_Umbrella_Root_CA.cer /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust

# RUN dnf install -y nginx=1.22.1-9 createrepo

# COPY src/nginx.conf /etc/nginx/nginx.conf
# COPY assets/devpi-cert.pem /etc/nginx/certs/cert.crt
# RUN echo "$SSL_CERT_KEY" >> /etc/nginx/certs/cert.key && \
#     chmod 700 /etc/nginx/certs/cert.crt && \
#     chmod 700 /etc/nginx/certs/cert.key
# COPY src/entrypoint.sh /scripts/entrypoint.sh
# COPY src/initial_setup.sh /scripts/initial_setup.sh
# COPY src/devpi-client /usr/local/bin/
# WORKDIR /data

# ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["bash"]

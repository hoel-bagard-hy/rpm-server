FROM rockylinux:9.3

ARG PROXY_IP
ARG PROXY_USERNAME
ARG PROXY_PASSWORD

# Set the proxy
RUN echo "proxy=$PROXY_IP:8080" >> /etc/dnf/dnf.conf && \
    echo "proxy_username=$PROXY_USERNAME" >> /etc/dnf/dnf.conf && \
    echo "proxy_password=$PROXY_PASSWORD" >> /etc/dnf/dnf.conf

# Add the Hitachi certificate
COPY assets/Cisco_Umbrella_Root_CA.cer /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust

COPY assets/hht.repo /etc/yum.repos.d/hht.repo

CMD ["bash"]

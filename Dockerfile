FROM docker.io/alpine:3.20.0
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"
LABEL org.opencontainers.image.title="dnsmasq",
LABEL org.opencontainers.image.source="https://github.com/poseidon/dnsmasq"
LABEL org.opencontainers.image.vendor="Poseidon Labs"
RUN apk -U add dnsmasq curl
COPY tftpboot /var/lib/tftpboot
EXPOSE 53 67 69
ENTRYPOINT ["/usr/sbin/dnsmasq"]

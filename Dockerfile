FROM docker.io/alpine:3.15.0
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"
RUN apk -U add dnsmasq curl dumb-init
COPY tftpboot /var/lib/tftpboot
EXPOSE 53 67 69
ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/sbin/dnsmasq"]

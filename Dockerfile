FROM docker.io/alpine:3.17.1
LABEL maintainer="Dalton Hubble <dghubble@gmail.com>"
RUN apk -U add dnsmasq curl
COPY tftpboot /var/lib/tftpboot
EXPOSE 53 67 69
ENTRYPOINT ["/usr/sbin/dnsmasq"]

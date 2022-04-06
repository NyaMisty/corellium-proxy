FROM jrei/systemd-ubuntu:20.04

RUN apt-get update && \
    apt-get install -y usbmuxd openvpn && \
    apt-get install -y avahi-daemon && \
    apt-get install -y ipcalc net-tools && \
    apt-get install -y socat && \
    apt-get install -y wget curl vim

COPY files/journald.conf /etc/systemd

COPY files/add_iprule.sh /opt
COPY files/*.service /etc/systemd/system/

RUN wget -O /tmp/usbfluxd.tar.gz https://github.com/corellium/usbfluxd/releases/download/v1.0/usbfluxd-x86_64-libc6-libdbus13.tar.gz && (cd /tmp; tar zxvf usbfluxd.tar.gz) && mv /tmp/usbfluxd-*/* /usr/local/bin && rm -rf /tmp/usbflux*

RUN wget -O /tmp/gost.gz https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz && gzip -d /tmp/gost.gz && mv /tmp/gost /usr/local/bin/gost && chmod +x /usr/local/bin/gost

RUN systemctl enable add_iprule
RUN systemctl enable usbfluxd usbfluxd-proxy
RUN systemctl enable openvpn@main socks-proxy
RUN systemctl enable avahi-daemon

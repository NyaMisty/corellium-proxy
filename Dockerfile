FROM jrei/systemd-ubuntu:22.04

RUN apt-get update && \
    apt-get install -y usbmuxd openvpn \
        avahi-daemon \
        ipcalc-ng net-tools \
        socat \
        wget curl vim

COPY files/journald.conf /etc/systemd

COPY files/*.sh /opt/
COPY files/*.service /etc/systemd/system/

RUN chmod -R +x /opt

RUN wget -O /tmp/usbfluxd.tar.gz https://github.com/corellium/usbfluxd/releases/download/v1.0/usbfluxd-x86_64-libc6-libdbus13.tar.gz && (cd /tmp; tar zxvf usbfluxd.tar.gz) && mv /tmp/usbfluxd-*/* /usr/local/bin && rm -rf /tmp/usbflux*

RUN wget -O /tmp/gost.gz https://github.com/ginuerzh/gost/releases/download/v2.11.1/gost-linux-amd64-2.11.1.gz && gzip -d /tmp/gost.gz && mv /tmp/gost /usr/local/bin/gost && chmod +x /usr/local/bin/gost

RUN touch /run/systemd/system && \
    wget -O /tmp/nps.tar.gz https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_server.tar.gz && (mkdir /tmp/nps; cd /tmp/nps; tar zxvf ../nps.tar.gz) && /tmp/nps/nps install && \
    rm -rf /tmp/nps && \
    wget -O /tmp/npc.tar.gz https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_client.tar.gz && (mkdir /tmp/npc; cd /tmp/npc; tar zxvf ../npc.tar.gz) && cp /tmp/npc/npc /usr/bin && \
    /usr/bin/npc install -server=localhost:8024 -vkey=corellium && rm -rf /tmp/npc && \
    rm /run/systemd/system

VOLUME /etc/nps/conf

RUN systemctl enable add_iprule
RUN systemctl enable usbfluxd usbfluxd-proxy
RUN systemctl enable corellium-openvpn socks-proxy
RUN systemctl enable avahi-daemon
RUN systemctl enable Nps Npc

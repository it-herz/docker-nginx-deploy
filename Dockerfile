FROM nginx:alpine

ADD init /etc/init.d/

RUN apk update && \
    apk add openssh sudo openrc bash && \
    #===================RC configure magic==================
    sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
    echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
    mkdir -p /run/openrc && touch /run/openrc/softlevel && \
    echo "/sbin/rc" >/root/rc && chmod +x /root/rc && \
    #=======================================================
    rc-update add local default && \
    rc-update add sshd sysinit && \
    rc-update add nginx sysinit && \
    mkdir -p /var/www/html && \
    chown nginx /var/www/html && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
    sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config

ADD startScript.start /etc/local.d

EXPOSE 22

ENTRYPOINT [ "/bin/bash", "--init-file", "/root/rc" ]

FROM nginx:alpine

ADD init /etc/init.d/

RUN apk update && \
    apk add openssh sudo openrc bash rsync && \
    #===================RC configure magic==================
    sed -i 's/#rc_sys=""/rc_sys="lxc"/g' /etc/rc.conf && \
    echo 'rc_provide="loopback net"' >> /etc/rc.conf && \
    sed -i 's/^#\(rc_logger="YES"\)$/\1/' /etc/rc.conf && \
    sed -i '/tty/d' /etc/inittab && \
    sed -i 's/hostname $opts/# hostname $opts/g' /etc/init.d/hostname && \
    sed -i 's/mount -t tmpfs/# mount -t tmpfs/g' /lib/rc/sh/init.sh && \
    sed -i 's/cgroup_add_service /# cgroup_add_service /g' /lib/rc/sh/openrc-run.sh && \
    #=======================================================
    #Cleanup
    rm /etc/nginx/conf.d/* && \ 
    rc-update add nginx sysinit && \
    rc-update add sshd sysinit && \
    rc-update add local default && \
    mkdir -p /var/www/html && \
    chown nginx /var/www/html && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
    sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config

ADD nginx.conf.d/nginx.conf /etc/nginx/
ADD nginx.conf.d/??-*.conf /etc/nginx/conf.d/
ADD 01-startScript.start /etc/local.d

EXPOSE 22 80
WORKDIR /var/www/html

CMD ["/sbin/init"]


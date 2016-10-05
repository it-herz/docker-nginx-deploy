FROM nginx:alpine

ADD nginx.init /etc/init.d/nginx

RUN apk update && \
    apk add openssh sudo openrc && \
    mkdir -p /var/www/html && \
    chown nginx /var/www/html && \
    rc-update add local default && \
    rc-update add sshd sysinit && \
    rc-update add nginx sysinit && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
    sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config

ADD startScript.start /etc/local.d

EXPOSE 22

ENTRYPOINT [ "/bin/bash", "--init-file", "/root/rc" ]

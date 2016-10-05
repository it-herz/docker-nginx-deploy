FROM nginx:alpine

RUN apk update && \
    apk add openssh sudo && \
    rc-update add ssh sysinit && \
    rc-update add nginx sysinit && \
    sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/ig' /etc/ssh/sshd_config && \
    sed -i 's/#RSAAuthentication.*/RSAAuthentication yes/ig' /etc/ssh/sshd_config

ADD startScript.start /etc/local.d

EXPOSE 22

ENTRYPOINT [ "/bin/bash", "--init-file", "/root/rc" ]

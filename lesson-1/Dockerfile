FROM ubuntu:xenial

LABEL maintainer="il.lenskii@gmail.com"

RUN apt-get update
RUN apt-get install -y openssh-server
RUN apt-get install -y nano
RUN apt-get install -y sudo
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y ansible

RUN mkdir /var/run/sshd

RUN useradd -rm -d /home/user -s /bin/bash -g root -G sudo -u 1001 user
RUN usermod -aG sudo user

RUN mkdir -p /home/user/.ssh
RUN chmod 700 /home/user/.ssh

COPY ./.ssh/id_rsa.pub /home/user/.ssh/authorized_keys

RUN mkdir -p /home/user/sopo
COPY /home/user/sopo /home/user/sopo

RUN chown -R user:root /home/user/

RUN echo 'user:1' | chpasswd

RUN sed -i 's/^#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
EXPOSE 80
CMD ["/usr/sbin/sshd", "-D"]

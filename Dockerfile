
FROM ubuntu:xenial
#FROM ubuntu:18.04


LABEL maintainer="il.lenskii@gmail.com"

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y git
RUN apt-get install -y nano

RUN mkdir /var/run/sshd

RUN useradd -rm -d /home/user -s /bin/bash -g root -G sudo -u 1001 user
RUN usermod -aG sudo user

RUN mkdir -p /home/user/.ssh
RUN chmod 700 /home/user/.ssh

#RUN mkdir -p /home/root/.ssh
#RUN chmod 700 /home/root/.ssh

COPY ./.ssh/id_rsa.pub /home/user/.ssh/authorized_keys
#COPY ./.ssh/id_rsa.pub /home/root/.ssh/authorized_keys

RUN chown -R user:root /home/user/

RUN echo 'user:1' | chpasswd
RUN echo 'root:1' | chpasswd

RUN sed -i 's/^#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

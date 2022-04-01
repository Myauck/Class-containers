FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server sudo nano
RUN mkdir /var/run/sshd

ARG PASSWD=856f25abe51fb58fa7171120fba29155audd
RUN echo -n "root:${PASSWD}" | chpasswd

RUN sed -i 's/\#PermitRootLogin prohibit-password/\PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's#root:x:0:0:root:/root:/bin/bash#root:x:0:0:root:/home/root:/bin/bash#' /etc/passwd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN cp -R /root /home
WORKDIR /home/root

# RUN rm /home/root/.bashrc
COPY content/bashrc /home/root/.bashrc
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN rm -rf /root
RUN chmod 666 /etc/update-motd.d/*
RUN chmod 777 /etc/update-motd.d/00-header /etc/update-motd.d/10-help-text

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22

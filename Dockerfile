FROM centos:6.4

MAINTAINER Tindaro Tornabene <tindaro.tornabene@gmail.com>


RUN yum -y install openssh-server
RUN useradd -mUs /bin/bash -p '$6$iKh435EZ$XF4mLsy9/hQKmeyE8pbSddiR7QfHT0Mo78fb0LYx6FaxCoJimKlUoCxWflrfgACG.dJxH0ZUdULp/5VOXdSFh.' user 
ADD sshd /etc/pam.d/sshd

VOLUME ["/home"]

EXPOSE 22
ADD start.sh /start.sh

RUN yum -y install sudo
ADD singleuser /etc/sudoers.d/singleuser
RUN chown root. /etc/sudoers.d/singleuser

RUN yum -y install perl sysstat nc libaio
RUN mkdir /tmp/zcs && cd /tmp/zcs && wget -O- http://files2.zimbra.com/downloads/8.0.7_GA/zcs-8.0.7_GA_6021.RHEL6_64.20140408123911.tgz | tar xz && chown -R user. /tmp/zcs
ADD config.defaults /tmp/zcs/config.defaults
ADD utilfunc.sh.patch /tmp/zcs/utilfunc.sh.patch
RUN cd /tmp/zcs/zcs-* && patch util/utilfunc.sh </tmp/zcs/utilfunc.sh.patch
RUN cd /tmp/zcs/zcs-* && ./install.sh -s --platform-override /tmp/zcs/config.defaults
RUN mv /opt/zimbra /opt/.zimbra

VOLUME ["/opt/zimbra"]

EXPOSE 22
EXPOSE 25
EXPOSE 456
EXPOSE 587
EXPOSE 110
EXPOSE 143
EXPOSE 993
EXPOSE 995
EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 8443
EXPOSE 7071

ADD start.sh /start.sh

CMD ["/start.sh"]
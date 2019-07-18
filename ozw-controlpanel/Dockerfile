############################################################
# Dockerfile to build OpenZWave Library container images
# Based on CentOS7
############################################################

# Set the base image to Ubuntu
FROM centos:centos7 as builder

# File Author / Maintainer
MAINTAINER Justin Hammond

# Add the package verification key
COPY /files/*.repo /etc/yum.repos.d/

# Update the repository sources list
RUN yum update -y && yum install epel-release -y && yum groupinstall 'Development Tools' -y 
RUN yum install tinyxml-devel libmicrohttpd-devel libopenzwave-devel gnutls-devel systemd-devel -y

RUN adduser ozwcp_user
USER ozwcp_user

ENV HOME /home/ozwcp_user

WORKDIR	$HOME
RUN git clone https://github.com/OpenZWave/open-zwave-control-panel.git

WORKDIR open-zwave-control-panel
COPY /files/Makefile .

RUN make

FROM centos:centos7 as final

# File Author / Maintainer
MAINTAINER Justin Hammond

RUN adduser ozwcp_user
RUN usermod -a -G dialout ozwcp_user
RUN usermod -a -G games ozwcp_user

COPY /files/*.repo /etc/yum.repos.d/
RUN yum install epel-release -y && yum install tinyxml libmicrohttpd libopenzwave gnutls -y

ENV HOME /home/ozwcp_user
WORKDIR	$HOME/open-zwave-control-panel

COPY --from=builder --chown=ozwcp_user:ozwcp_user $HOME/open-zwave-control-panel .
RUN chown ozwcp_user:ozwcp_user .

USER ozwcp_user
EXPOSE 8008
ENTRYPOINT ["./ozwcp", "-p 8008"]



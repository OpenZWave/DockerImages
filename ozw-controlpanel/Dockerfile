############################################################
# Dockerfile to build OpenZWave Library container images
# Based on CentOS7
############################################################

# Set the base image to Ubuntu
FROM centos:centos7

# File Author / Maintainer
MAINTAINER Justin Hammond

WORKDIR /etc/yum.repos.d/


# Add the package verification key
RUN yum install wget -y && wget http://mirror.my-ho.st/Downloads/OpenZWave%3A/Devel/CentOS_CentOS-7/OpenZWave%3ADevel.repo

# Update the repository sources list
RUN yum update -y && yum groupinstall 'Development Tools' -y && yum install libmicrohttpd-devel libopenzwave-devel gnutls-devel systemd-devel -y


################## BEGIN INSTALLATION ######################
# Install MongoDB Following the Instructions at MongoDB Docs
# Ref: http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/


RUN adduser ozwcp_user
RUN usermod -a -G dialout ozwcp_user
RUN usermod -a -G games ozwcp_user

USER ozwcp_user
ENV HOME /home/ozwcp_user

WORKDIR	$HOME

RUN git clone https://github.com/OpenZWave/open-zwave-control-panel.git

WORKDIR $HOME/open-zwave-control-panel

COPY /files/Makefile $HOME/open-zwave-control-panel/
ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinyxml.h $HOME/open-zwave-control-panel/
ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinystr.h $HOME/open-zwave-control-panel/

USER root
RUN chown ozwcp_user $HOME/open-zwave-control-panel/tiny*
USER ozwcp_user


RUN make


USER root
RUN yum grouperase 'Development Tools' -y
RUN yum erase libmicrohttpd-devel libopenzwave-devel systemd-container-devel -y

USER ozwcp_user
EXPOSE 8008
ENTRYPOINT ["/home/ozwcp_user/open-zwave-control-panel/ozwcp", "-p 8008"]



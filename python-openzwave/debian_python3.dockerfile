# Python3 openzwave docker image
# https://github.com/OpenZWave/python-openzwave
# bibi21000
#
################################################################################

FROM		debian:latest
MAINTAINER	bibi21000 <bibi21000@gmail.com>

################################################################################
#Add user
USER		root

RUN adduser ozw_user
RUN usermod -a -G dialout ozw_user
RUN usermod -a -G games ozw_user

RUN mkdir -p /usr/local/src/

################################################################################
# Initial prerequisites
USER		root
ENV			DEBIAN_FRONTEND	noninteractive
RUN			apt-get -y update && apt-get -y install \
				apt-transport-https \
				g++ \
				python3-all python3-dev python3-pip \
				libbz2-dev \
				libssl-dev \
				libudev-dev \
				libyaml-dev \
				make \
				git \
				wget \
				sudo \
				zlib1g-dev \
				libmicrohttpd-dev \
				gnutls-bin libgnutls28-dev \
				pkg-config 

RUN 		pip3 install 'PyDispatcher>=2.0.5' six

################################################################################
# Install python_openzwave with embed sources as a shared module
RUN			pip3 install python_openzwave --install-option="--flavor=embed_shared"

################################################################################
# Install open-zwave-controlpanel
USER		root

WORKDIR	/usr/local/src/

RUN git clone https://github.com/OpenZWave/open-zwave-control-panel.git

WORKDIR /usr/local/src/open-zwave-control-panel

COPY /files/Makefile.ozwcp /usr/local/src/open-zwave-control-panel/Makefile
ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinyxml.h /usr/local/src/open-zwave-control-panel/
ADD https://raw.githubusercontent.com/OpenZWave/open-zwave/master/cpp/tinyxml/tinystr.h /usr/local/src/open-zwave-control-panel/

RUN make

RUN ln -s /usr/local/bin/open-zwave-control-panel/ozwcp /usr/local/bin/ozwcp

################################################################################
USER ozw_user
RUN mkdir -p $HOME/user_config
WORKDIR		$HOME/user_config
VOLUME		$HOME/user_config
EXPOSE 8008
ENTRYPOINT [ "/bin/bash", "/usr/local/bin/ozwcp", "-p 8008"]

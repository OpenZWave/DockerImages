#
# Makefile for OpenzWave Control Panel application
# Greg Satz

# GNU make only

.SUFFIXES:	.cpp .o .a .s

CC     := $(CROSS_COMPILE)gcc
CXX    := $(CROSS_COMPILE)g++
LD     := $(CROSS_COMPILE)g++
AR     := $(CROSS_COMPILE)ar rc
RANLIB := $(CROSS_COMPILE)ranlib

DEBUG_CFLAGS    := -Wall -Wno-unknown-pragmas -Wno-inline -Werror -Wno-format -g -DDEBUG -ggdb -O0
RELEASE_CFLAGS  := -Wall -Wno-unknown-pragmas -Werror -Wno-format -O3 -DNDEBUG

DEBUG_LDFLAGS	:= -g

# Change for DEBUG or RELEASE
CFLAGS	:= -c $(DEBUG_CFLAGS)
LDFLAGS	:= $(DEBUG_LDFLAGS)

LIBMICROHTTPD := -lmicrohttpd

INCLUDES := $(shell ozw_config --Cflags)

# Remove comment below for gnutls support
GNUTLS := -lgnutls

# for Linux uncomment out next three lines
LIBZWAVE := -lopenzwave
LIBUSB := -ludev
LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB)

# for Mac OS X comment out above 2 lines and uncomment next 5 lines
#ARCH := -arch i386 -arch x86_64
#CFLAGS += $(ARCH)
#LIBZWAVE := $(wildcard $(OPENZWAVE)/cpp/lib/mac/*.a)
#LIBUSB := -framework IOKit -framework CoreFoundation
#LIBS := $(LIBZWAVE) $(GNUTLS) $(LIBMICROHTTPD) -pthread $(LIBUSB) $(ARCH)

%.o : %.cpp
	$(CXX) $(CFLAGS) -I. $(INCLUDES) $(INCLUDES)/platform/ $(INCLUDES)/command_classes/ $(INCLUDES)/value_classes/ -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ $<

all: ozwcp


#defs:
#ifeq ($(LIBZWAVE),)
#	@echo Please edit the Makefile to avoid this error message.
#	@exit 1
#endif

ozwcp.o: ozwcp.h webserver.h /usr/include/openzwave/Options.h /usr/include/openzwave/Manager.h \
	/usr/include/openzwave/Node.h /usr/include/openzwave/Group.h \
	/usr/include/openzwave/Notification.h /usr/include/openzwave/platform/Log.h

webserver.o: webserver.h ozwcp.h /usr/include/openzwave/Options.h /usr/include/openzwave/Manager.h \
	/usr/include/openzwave/Node.h /usr/include/openzwave/Group.h \
	/usr/include/openzwave/Notification.h /usr/include/openzwave/platform/Log.h

ozwcp:	ozwcp.o webserver.o zwavelib.o $(LIBZWAVE)
	$(LD) -o $@ $(LDFLAGS) ozwcp.o webserver.o zwavelib.o $(LIBS)

dist:	ozwcp
	rm -f ozwcp.tar.gz
	tar -c --exclude=".svn" -hvzf ozwcp.tar.gz ozwcp config/ cp.html cp.js openzwavetinyicon.png README

clean:
	rm -f ozwcp *.o

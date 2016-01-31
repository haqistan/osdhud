# -*- makefile -*-
##
# osdhud settings on BSD systems
##

# BSD command defaults

INSTALL?=install -vC
INSTALL_D?=install -d
MANDOC?=mandoc
ECHO?=echo
SED?=sed
CAT?=cat
CP?=cp
LN?=ln
RM=rm
TAR?=tar
TAR_CF?=$(TAR) cf
TAR_XF?=$(TAR) xf
GZIP?=gzip
MKDIR?=mkdir
MKDIR_P?=$(MKDIR) -p
SUSS?=./suss.pl
INSTALL?=install
INSTALL_X?=$(INSTALL)
INSTALL_D?=$(INSTALL) -d

# this is in config.mk
#PREFIX?=/usr/local

BINDIR?=$(PREFIX)/bin
LIBDIR?=$(PREFIX)/lib
MANDIR?=$(PREFIX)/man

VERSION!=cat $(S)/VERSION
UNAME!=uname | tr A-Z a-z

.if ${UNAME} == "openbsd"
PTHREAD_CFLAGS=
PTHREAD_LDFLAGS=
PTHREAD_LIBS=-lpthread
.elif ${UNAME} == "freebsd"  
PTHREAD_CFLAGS!=pthread-config --cflags
PTHREAD_LDFLAGS!=pthread-config --ldflags
PTHREAD_LIBS!=pthread-config --libs
.endif

## N.B. xosd-config --cflags output is obnoxious, at least on my box:
##   $ xosd-config --cflags
##   -O2 -pipe -fno-strict-aliasing -std=gnu89 -I/usr/local/include -Wall
## They should not be deciding about -Wall, -pipe, -O2 etc for me.
## Irritating.  Typical.  I therefore ignore the output of
## xosd-config --cflags and roll my own for BSD.

XOSD_LIBS!=xosd-config --libs
XOSD_CFLAGS=-I/usr/local/include -I/usr/X11R6/include

## Judy doesn't seem to play with any of the meta-config things:
JUDY_LIBS=-lJudy

C_WARNINGS?=-Wall -Werror
C_DEBUGGING?=-g -ggdb $(C_WARNINGS)
C_OPTIMIZED?=-O2 -pipe $(C_WARNINGS)
#CFLAGS=$(C_DEBUGGING) $(XOSD_CFLAGS) $(PTHREAD_CFLAGS)
CFLAGS+=$(C_DEBUGGING) $(XOSD_CFLAGS)
LDFLAGS+=$(XOSD_LDFLAGS)
LIBS+=$(XOSD_LIBS) $(JUDY_LIBS) $(PTHREAD_LIBS)
#LIBS+=$(XOSD_LIBS)
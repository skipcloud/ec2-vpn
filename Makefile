PROG=ec2-vpn
TARGET=$(shell pwd)/${PROG}
LINK=/usr/local/bin/${PROG}

install:
	ln -sf ${TARGET} ${LINK}
.PHONY: install

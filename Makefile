C_FLAGS ?= -Izlog/src -IwiringPi/wiringPi -O2 -g -Wall -D_GNU_SOURCE 
LD_LIBS ?= -Lzlog/src -lzlog -LwiringPi/wiringPi -lwiringPi -lpthread
LD_FLAGS ?= -O2 -g
INSTALL_DIR ?= /

CC ?= gcc
ifneq ($(CROSS_COMPILE),)
CC = $(CROSS_COMPILE)gcc
endif

SRCS += src/main.c \
		src/socket_tranceiver.c \
		src/orbit_parser.c \
		src/command_processor.c

OBJS := $(addsuffix .o,$(basename $(SRCS)))

.PHONY: all zlog wiringPi clean OrbitIO

all: OrbitIO

OrbitIO: zlog wiringPi $(OBJS)
	$(shell rm -f wiringPi/wiringPi/libwiringPi.so)
	$(shell ln -s libwiringPi.so.2.0 wiringPi/wiringPi/libwiringPi.so)
	@mkdir -p output
	@cp -f zlog/src/libzlog.so* output
	@cp -f wiringPi/wiringPi/libwiringPi.so* output
	@echo "LD output/OrbitIO"
	@$(CC) $(LD_FLAGS) -o output/OrbitIO $(OBJS) $(LD_LIBS)

zlog:
	@echo "Compile zlog"
	CROSS_COMPILE=$(CROSS_COMPILE) make -C zlog 

wiringPi:
	@echo "Compile wiringPi"
	CROSS_COMPILE=$(CROSS_COMPILE) make -C wiringPi/wiringPi

%.o: %.c
	@echo "CC $<"
	@$(CC) -c $(C_FLAGS) $< -o $@

clean:
	@echo "Clean zlog"
	make -C zlog clean
	@echo "Clean wiringPi"
	make -C wiringPi/wiringPi clean
	@echo "Clean OrbitIO"
	$(shell find src -name "*.o" | xargs rm -f)
	@rm -Rf output

install:
	@echo "Install zlog and wiringPi into library $(INSTALL_DIR)/usr/lib"
	@mkdir -p $(INSTALL_DIR)/usr/lib
	@cp -f output/*.so* $(INSTALL_DIR)/usr/lib/
	@echo "Install OrbitIO into binary dir $(INSTALL_DIR)/usr/bin"
	@mkdir -p $(INSTALL_DIR)/usr/bin
	@cp -f output/OrbitIO $(INSTALL_DIR)/usr/bin/
	@echo "Install zlog config into config dir $(INSTALL_DIR)/etc"
	@mkdir -p $(INSTALL_DIR)/etc
	@cp -f conf/orbitio.conf $(INSTALL_DIR)/etc/

uninstall:
	@echo "Remove zlog and wiringPi from library dir $(INSTALL_DIR)/usr/lib"
	@rm -f $(INSTALL_DIR)/usr/lib/libzlog.so*
	@rm -f $(INSTALL_DIR)/usr/lib/libwiringPi.so*
	@echo "Remove OrbitIO from binary dir $(INSTALL_DIR)/usr/bin"
	@rm -f $(INSTALL_DIR)/usr/bin/OrbitIO
	@echo "Remove zlog config from config dir $(INSTALL_DIR)/etc"
	@rm -f $(INSTALL_DIR)/etc/orbitio.conf
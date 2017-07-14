

CFLAGS=-O2 -I.
LDFLAGS=-lm


#####################################################
# Uncomment this 2 lines if you want to enable ZeroMQ
#####################################################
#CFLAGS+= -DHAVE_ZMQ
#ZMQ_LDFLAGS:= -lzmq


##################################################
# Uncomment this 2 lines if you want to enable FEC
##################################################
#CFLAGS+= -DHAVE_FEC
#FEC_LDFLAGS:= -lfec


all: cleanapps ts2na na2ni ni2http edi2eti

edi2eti:
	gcc -g $(CFLAGS) -Wall -o edi2eti network.c af_parser.c pf_parser.c tag_parser.c crc.c eti_assembler.c logging.c edi2eti.c -lfec -lzmq

ts2na:
	gcc -g $(CFLAGS) -Wall -o ts2na ts2na.c

ts2na_dreambox:
	gcc -g $(CFLAGS) -Wall -o ts2na ts2na.c tune.c

na2ni:
	gcc -g $(CFLAGS) -Wall -o na2ni na2ni.c $(LDFLAGS) $(FEC_LDFLAGS)

ni2http:
	test -f ./libshout-2.2.2/src/.libs/libshout.a || { tar -xvzf libshout-2.2.2.tar.gz; cd libshout-2.2.2; ./configure --enable-shared=no --enable-static=yes; make; cd ..; }
	gcc -g $(CFLAGS) -Wall -o ni2http ni2http.c wffigproc.c wfficproc.c wfbyteops.c wftables.c wffirecrc.c wfcrc.c parse_config.c $(LDFLAGS) -I./libshout-2.2.2/include ./libshout-2.2.2/src/.libs/libshout.a -lpthread  $(FEC_LDFLAGS) $(ZMQ_LDFLAGS)

cleanapps:
		rm -f *.o
		rm -f ts2na na2ni ni2http edi2eti

clean: cleanapps
		if [ -f ./libshout-2.2.2/src/.libs/libshout.a ]; then cd libshout-2.2.2; make clean; cd ..;  fi;

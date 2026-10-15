ifndef CPPUTEST_HOME
$(error CPPUTEST_HOME is not set. Build with Docker (see README.md) or point it at a CppUTest v4.0 checkout)
endif
export CPPUTEST_HOME

all: cpputest
	@echo CPPUTEST_HOME is $(CPPUTEST_HOME)
	make -i -C code
	make -i -C code-t0
	make -i -C code-t1
	make -i -C code-t2
	make -i -C code-t3

clean:
	make -i -C code clean
	make -i -C code-t0 clean
	make -i -C code-t1 clean
	make -i -C code-t2 clean
	make -i -C code-t3 clean

.PHONY: cpputest
cpputest: $(CPPUTEST_HOME)/lib/libCppUTest.a

$(CPPUTEST_HOME)/lib/libCppUTest.a:
	cd $(CPPUTEST_HOME); autoreconf . -i && ./configure && make tdd

GPDK = /opt/tools/technology/cadence/gpdk/45nm/
STDCLIB = $(GPDK)/gsclib045_svt_v4.4/gsclib045/verilog/fast_vdd1v2_basicCells.v

WORKLIB = work
SRC = 	../src/signed_mult.v \
	../src/tb_signed_mult.v

NCVLOG_OPTS = -cdslib ../cds.lib -work $(WORKLIB)
NCELAB_OPTS = -cdslib ../cds.lib -work $(WORKLIB) -messages -ACCESS +rwc -timescale 1ns/10ps
NCSIM_OPTS = -cdslib ../cds.lib

targets:
	@echo "targets: [ genlib | signed_mult | clean ]"

genlib:
	@-mkdir -p ../compiled/work
	echo "compiling library..."
	ncvlog $(NCVLOG_OPTS) $(STDCLIB)

signed_mult:
	echo "compiling multiplier..."
	ncvlog  $(NCVLOG_OPTS) -linedebug $(SRC)

	ncelab $(NCELAB_OPTS) testbench
#:	ncsim $(NCSIM_OPTS) -input input.cmd testbench
	ncsim $(NCSIM_OPTS) -gui testbench

clean:
	rm -rf $(wildcard *.log *.key *~) ../compiled waves.shm


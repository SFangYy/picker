PYTHON_INCLUDE:=$(firstword $(shell python3-config --includes))
XSP_COMM_INCLUDE:="{{__XSPCOMM_INCLUDE__}}"

# Path management for new structure
# Top folder: <TransactionName>/
# Module folder: <TransactionName>/DUT<TransactionName>/
# Build folder: <TransactionName>/DUT<TransactionName>/csrc/
TOP_DIR := $(CURDIR)
DUT_MODULE := DUT{{className}}
BUILD_DIR := $(DUT_MODULE)/csrc

# Validate required environment variables
ifndef UVMC_HOME
$(error UVMC_HOME is not set)
endif
ifndef VCS_HOME
$(error VCS_HOME is not set)
endif
ifndef UVM_HOME
$(error UVM_HOME is not set)
endif
ifndef XSP_COMM_INCLUDE
$(error XSP_COMM_INCLUDE is not set)
endif
ifndef PYTHON_INCLUDE
$(error PYTHON_INCLUDE is not set)
endif


VERBOSE=+UVM_VERBOSITY=UVM_MEDIUM

SYSCAN  = syscan -cpp g++ -cc gcc -full64 -cflags -g -cflags -DVCS -cflags -I. \
                -tlm2 -cflags -I${VCS_HOME}/include/systemc232/tlm_utils \
                -cflags -I${UVMC_HOME}/src/connect/sc ${UVMC_HOME}/src/connect/sc/uvmc.cpp \
                -cflags -DUSE_VCS -cflags ${PYTHON_INCLUDE} -cflags -I${XSP_COMM_INCLUDE}

VLOGAN  = vlogan -q -full64 \
         -sverilog +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm_pkg.sv \
        +incdir+${UVMC_HOME}/src/connect/sv ${UVMC_HOME}/src/connect/sv/uvmc_pkg.sv \
         -timescale=1ns/1ps +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \

VCS_ELAB = vcs -sysc=deltasync -lca \
        -full64 -sysc -cpp g++ -cc gcc \
        -timescale=1ns/1ps \
        -CFLAGS -DVCS ${UVM_HOME}/src/dpi/uvm_dpi.cc \
        -e VcsMain sv_main ${VCS_HOME}/linux64/lib/vcs_tls.o -slave

VCS    = vcs -q -sysc=deltasync -lca -full64 \
        -sverilog +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm_pkg.sv \
        +incdir+${UVMC_HOME}/src/connect/sv ${UVMC_HOME}/src/connect/sv/uvmc_pkg.sv \
        -timescale=1ns/1ps \
        -sysc -cpp g++ -cc gcc \
        -CFLAGS -DVCS ${UVM_HOME}/src/dpi/uvm_dpi.cc

# Default target: compile and run
all: clean comp copy_xspcomm run

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(DUT_MODULE)/csrc $(DUT_MODULE)/work $(DUT_MODULE)/.vlogan*
	rm -rf $(DUT_MODULE)/_tlm_pbsb.so* $(DUT_MODULE)/simv* 
	rm -rf $(DUT_MODULE)/ucli.key $(DUT_MODULE)/vc_hdrs.h 
	rm -rf $(DUT_MODULE)/vcs.log $(DUT_MODULE)/AN* $(DUT_MODULE)/*.log 
	rm -rf $(DUT_MODULE)/*.log.cmp $(DUT_MODULE)/*.vpd $(DUT_MODULE)/DVE*
	rm -rf $(DUT_MODULE)/tlm_pbsb.py
	rm -rf __pycache__ $(DUT_MODULE)/__pycache__
	@echo "Clean complete."

# Compile target (unified for both regular and DUT mode)
comp:
	@mkdir -p $(BUILD_DIR)
	swig -D'MODULE_NAME="tlm_pbsb"' -python -c++ -DUSE_VCS -I${XSP_COMM_INCLUDE} \
		-outdir $(DUT_MODULE) -o $(BUILD_DIR)/tlmps.cpp \
		${XSP_COMM_INCLUDE}/xspcomm/python_tlm_pbsb.i
	$(SYSCAN) -Mdir=$(DUT_MODULE)/csrc \
		${XSP_COMM_INCLUDE}/xspcomm/tlm_pbsb.cpp $(BUILD_DIR)/tlmps.cpp
	$(VLOGAN) +incdir+$(DUT_MODULE) example_uvm_dut.sv -Mdir=$(DUT_MODULE)/csrc
	$(VCS_ELAB) -o $(DUT_MODULE)/_tlm_pbsb.so -Mdir=$(DUT_MODULE)/csrc

# Copy xspcomm library to DUT module directory
copy_xspcomm:
	@cp -r {{__XSPCOMM_PYTHON__}} $(DUT_MODULE)/xspcomm

# Run DUT example
run:
	@if [ -f example_dut.py ]; then \
		cd $(DUT_MODULE) && LD_PRELOAD=./_tlm_pbsb.so python3 ../example_dut.py; \
	else \
		echo "Error: example_dut.py not found!"; \
		exit 1; \
	fi

# Help target
help:
	@echo "Available targets:"
	@echo "  make all          - Clean, compile, copy xspcomm, and run"
	@echo "  make clean        - Remove all build artifacts"
	@echo "  make comp         - Compile UVM testbench"
	@echo "  make copy_xspcomm - Copy xspcomm library to module directory"
	@echo "  make run          - Run the DUT example"
	@echo "  make help         - Show this help message"

.PHONY: all clean comp copy_xspcomm run help
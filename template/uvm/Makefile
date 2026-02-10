# =========================================================
# File name    : Makefile
# Author       : Optimized & Dependency-Aware Version
# Module name  : Makefile for {{package_name}} verification
# Description  : Streamlined UVM-Python integration with incremental build
# =========================================================

# Path configuration
PYTHON_INCLUDE  := $(firstword $(shell python3-config --includes))
PYTHON_LDFLAGS  := $(shell python3-config --ldflags --embed)
PYTHON_LIB_DIR  := $(shell python3-config --configdir)
XSP_COMM_INCLUDE:={{__XSPCOMM_INCLUDE__}}
XSP_PYTHON:={{__XSPCOMM_PYTHON__}}

# Directory structure
TOP_DIR    := $(CURDIR)
PKG_DIR    := {{package_name}}
BUILD_DIR  := $(PKG_DIR)/build
LIB_SO     := $(PKG_DIR)/_tlm_pbsb.so

# Environment validation
REQUIRED_VARS = UVMC_HOME VCS_HOME UVM_HOME VERDI_HOME
$(foreach var,$(REQUIRED_VARS),$(if $(value $(var)),,$(error $(var) is not set)))
ifndef XSP_COMM_INCLUDE
$(error XSP_COMM_INCLUDE is not set)
endif

# Tools & Options
TIMESCALE := 1ns/1ps

SYSCAN = syscan -cpp g++ -cc gcc -full64 -cflags -g -tlm2 \
         -cflags -I${VCS_HOME}/include/systemc232/tlm_utils \
         -cflags -I${UVMC_HOME}/src/connect/sc -cflags -DVCS -cflags -DUSE_VCS \
         -cflags "${PYTHON_INCLUDE}" -cflags -I${XSP_COMM_INCLUDE} \
         ${UVMC_HOME}/src/connect/sc/uvmc.cpp \
         ${XSP_COMM_INCLUDE}/xspcomm/tlm_pbsb.cpp

VLOGAN = vlogan -q -full64 -sverilog +incdir+${UVM_HOME}/src ${UVM_HOME}/src/uvm_pkg.sv \
         +incdir+${UVMC_HOME}/src/connect/sv ${UVMC_HOME}/src/connect/sv/uvmc_pkg.sv \
         -timescale=${TIMESCALE} +define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR \
         +define+UVM_REGEX_NO_DPI +define+UVMC_NO_COMMANDS +define+DEF_SETUP_TIME=1step \
         +define+DEF_HOLD_TIME=1step +incdir+${UVM_HOME}/src

VCS_ELAB = vcs -sysc=deltasync -lca -full64 -sysc -cpp g++ -cc gcc -timescale=${TIMESCALE} \
           -P ${VERDI_HOME}/share/PLI/VCS/LINUX64/novas.tab ${VERDI_HOME}/share/PLI/VCS/LINUX64/pli.a \
           -CFLAGS "-DVCS ${PYTHON_INCLUDE}" \
           -LDFLAGS "$(PYTHON_LDFLAGS) -Wl,-rpath,$(PYTHON_LIB_DIR)" \
           ${UVM_HOME}/src/dpi/uvm_dpi.cc -uvm \
           -o $(LIB_SO) \
           -e VcsMain sv_main ${VCS_HOME}/linux64/lib/vcs_tls.o -slave -Mdir=${BUILD_DIR}

.PHONY: all clean comp copy_xspcomm run help

all: clean comp copy_xspcomm run

# Incremental Compilation:
$(LIB_SO): ${XSP_COMM_INCLUDE}/xspcomm/python_tlm_pbsb.i
	@echo "--- Step 1: Running SWIG ---"
	@mkdir -p $(BUILD_DIR)
	@swig -D'MODULE_NAME="tlm_pbsb"' -python -c++ -DUSE_VCS -I${XSP_COMM_INCLUDE} \
		-outdir $(PKG_DIR) -o ${BUILD_DIR}/tlmps.cpp \
		${XSP_COMM_INCLUDE}/xspcomm/python_tlm_pbsb.i
	@echo "--- Step 2: Running SYSCAN ---"
	@$(SYSCAN) -Mdir=${BUILD_DIR} ${BUILD_DIR}/tlmps.cpp
	@echo "--- Step 3: Running VLOGAN ---"
	@if [ -f example-uvm.sv ]; then \
		UVM_FILE=example-uvm.sv; \
	elif [ -f example.sv ]; then \
		UVM_FILE=example.sv; \
	else \
		echo "Error: No example UVM file found (example.sv or example-uvm.sv)!"; \
		exit 1; \
	fi; \
	{% if rtl_file_path -%}
	$(VLOGAN) +incdir+$(PKG_DIR) {{rtl_file_path}} $$UVM_FILE -Mdir=$(BUILD_DIR)
	{% else -%}
	$(VLOGAN) +incdir+$(PKG_DIR) $$UVM_FILE -Mdir=$(BUILD_DIR)
	{% endif -%}
	@echo "--- Step 4: Running VCS Elaboration ---"
	@$(VCS_ELAB)
	@echo "Cleaning build artifacts..."
	@rm -rf $(BUILD_DIR)
	@rm -f $(PKG_DIR)/vc_hdrs.h $(PKG_DIR)/ucli.key
	@echo "✓ Compilation complete"

comp: $(LIB_SO)

copy_xspcomm:
	@cp -r ${XSP_PYTHON}/xspcomm $(PKG_DIR)/xspcomm

run:
	@if [ -f example.py ]; then \
		cd $(TOP_DIR) && LD_PRELOAD=$(LIB_SO) python3 example.py; \
	else \
		echo "Error: No example file found (example.py)!"; \
		exit 1; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	@rm -rf $(PKG_DIR)/build $(PKG_DIR)/work $(PKG_DIR)/.vlogan*
	@rm -rf $(PKG_DIR)/_tlm_pbsb.so* $(PKG_DIR)/simv* 
	@rm -rf $(PKG_DIR)/vcs.log $(PKG_DIR)/AN* $(PKG_DIR)/*.log 
	@rm -rf $(PKG_DIR)/*.log.cmp $(PKG_DIR)/*.vpd $(PKG_DIR)/DVE*
	@rm -rf __pycache__ $(PKG_DIR)/__pycache__
	@echo "Clean complete."

help:
	@echo "Available targets:"
	@echo "  make all          - Clean, compile, copy xspcomm, and run"
	@echo "  make clean        - Remove all build artifacts"
	@echo "  make comp         - Compile UVM testbench"
	@echo "  make copy_xspcomm - Copy xspcomm library to package directory"
	@echo "  make run          - Run the example"
	@echo "  make help         - Show this help message"
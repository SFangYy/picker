#!/bin/bash
set -e

ROOT=$(pwd)
PACK_OUT="$ROOT/pack_output"

prepare() {
    rm -rf "$PACK_OUT"
    mkdir -p "$PACK_OUT" && cd "$PACK_OUT"
}

test_dut() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    "$ROOT/build/bin/picker" pack adder_trans.sv -d -e
    cp adder_trans.sv adder_trans/
    cd adder_trans
    make clean comp copy_xspcomm run
}

test_multi() {
    prepare
    cp "$ROOT/example/Pack/MultiTransALU"/{alu_op.sv,alu_result.sv,filelist.txt} .
    cp "$ROOT/example/Pack/Makefile.common" ./Makefile
    cp "$ROOT/example/Pack/MultiTransALU/test_alu.py" .
    cp "$ROOT/example/Pack/MultiTransALU/test_alu_uvm.sv" .
    "$ROOT/build/bin/picker" pack -f filelist.txt -n ALU -d 
    make clean comp copy_xspcomm run
}

test_recv() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Pack/Makefile.common" ./Makefile
    "$ROOT/build/bin/picker" pack adder_trans.sv
    cp adder_trans.sv adder_trans_pkg/
    cp "$ROOT/example/Pack/Python2UVM/example_python.py" .
    cp "$ROOT/example/Pack/Python2UVM/example_uvm.sv" .
    make clean comp copy_xspcomm run
}

test_send() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Pack/Makefile.common" ./Makefile
    "$ROOT/build/bin/picker" pack adder_trans.sv
    cp adder_trans.sv adder_trans_pkg/
    cp "$ROOT/example/Pack/UVM2Python/example_python.py" .
    cp "$ROOT/example/Pack/UVM2Python/example_uvm.sv" .
    make clean comp copy_xspcomm run
}

case "${1:-dut}" in
    dut)   test_dut   ;;
    multi) test_multi ;;
    recv)  test_recv  ;;
    send)  test_send  ;;
    all)   test_dut && test_multi && test_recv && test_send ;;
    *)     echo "Usage: bash example/Pack/release-pack.sh {dut|multi|recv|send|all}"; exit 1 ;;
esac

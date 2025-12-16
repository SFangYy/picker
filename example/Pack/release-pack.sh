#!/bin/bash
set -e

ROOT=$(pwd)
PACK_OUT="$ROOT/pack_output"

prepare() {
    rm -rf "$PACK_OUT"
    mkdir -p "$PACK_OUT" && cd "$PACK_OUT"
}

test_basic() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Pack/Makefile" .
    "$ROOT/build/bin/picker" pack adder_trans.sv -e
    cp adder_trans.sv adder_trans_pkg/

    make clean comp copy_xspcomm run
}

test_send() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Pack/Makefile" .
    "$ROOT/build/bin/picker" pack adder_trans.sv
    cp adder_trans.sv adder_trans_pkg/
    cp "$ROOT/example/Pack/01_Py2UVM/example.py" .
    cp "$ROOT/example/Pack/01_Py2UVM/example.sv" .
    make clean comp copy_xspcomm run
}

test_recv() {
    prepare
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Pack/Makefile" .
    "$ROOT/build/bin/picker" pack adder_trans.sv
    cp adder_trans.sv adder_trans_pkg/
    cp "$ROOT/example/Pack/02_UVM2Py/example.py" .
    cp "$ROOT/example/Pack/02_UVM2Py/example.sv" .
    make clean comp copy_xspcomm run
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
    mkdir -p multi_trans && cd multi_trans
    cp "$ROOT/example/Pack/04_MultiTrans"/{alu_op.sv,alu_result.sv,filelist.txt} .
    cp "$ROOT/example/Pack/Makefile" .
    cp "$ROOT/example/Pack/04_MultiTrans/example.py" .
    cp "$ROOT/example/Pack/04_MultiTrans/example.sv" .
    "$ROOT/build/bin/picker" pack -f filelist.txt -n ALU -d 
    make clean comp copy_xspcomm run
}

test_adder() {
    prepare
    mkdir -p adder && cd adder
    cp "$ROOT/example/Pack/adder_trans.sv" .
    cp "$ROOT/example/Adder/Adder.v" .
    cp "$ROOT/example/Pack/05_FullAdderDemo/example.sv" .
    cp "$ROOT/example/Pack/05_FullAdderDemo/example.py" .
    cp "$ROOT/example/Pack/Makefile" .
    "$ROOT/build/bin/picker" pack adder_trans.sv -d
    make clean comp copy_xspcomm run
}

case "${1:-dut}" in
    dut)   test_dut   ;;
    multi) test_multi ;;
    recv)  test_recv  ;;
    send)  test_send  ;;
    adder) test_adder ;;
    all)   test_dut && test_multi && test_recv && test_send && test_adder ;;
    *)     test_basic; exit 1 ;;
esac

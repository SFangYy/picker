rm -rf pack_example
mkdir pack_example && cd pack_example

cp ../example/Pack/adder_trans.sv .

if [ "$1" = "dut" ]; then
    echo "=== Testing DUT generation and execution ==="
    ../build/bin/picker pack adder_trans.sv -d -e
    cd adder_trans/example
    echo "=== Compiling DUT example ==="
    make clean comp_dut copy_xspcomm
    echo "=== Running DUT example ==="
    make run_dut
    
elif [ "$1" = "both" ]; then
    ../build/bin/picker pack adder_trans.sv -e
    cd adder_trans/example && make 

elif [ "$1" = "send" ]; then
    ../build/bin/picker pack adder_trans.sv -e
    cp -r ../example/Pack/UVM2Python . && cd UVM2Python
    cp ../adder_trans/example/Makefile .
    make
    
elif [ "$1" = "receive" ]; then
    ../build/bin/picker pack adder_trans.sv -e
    cp -r ../example/Pack/Python2UVM . && cd Python2UVM
    cp ../adder_trans/example/Makefile .
    make
    
else
    echo "Usage: $0 {dut|both|send|receive}"
    echo "  dut     - Test DUT abstraction class generation"
    echo "  both    - Test bidirectional communication"
    echo "  send    - Test UVM to Python (monitor)"
    echo "  receive - Test Python to UVM (driver)"
    exit 1
fi
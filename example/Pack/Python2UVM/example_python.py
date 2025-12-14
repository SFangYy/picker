import sys
import os
# Script runs from parent dir, adder_trans_pkg is a subdirectory
sys.path.insert(0, '.')
from adder_trans_pkg.adder_trans_xagent import *

if __name__ == "__main__":

    agent = Agent("adder_trans")
    
    for i in range(10):
        sequence = adder_trans()
        sequence.a.value = i
        sequence.b.value = i + 1
        sequence.send(agent)
        agent.run(1)


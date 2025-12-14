import sys
import os
# Script runs from parent dir, adder_trans_pkg is a subdirectory
sys.path.insert(0, '.')
from adder_trans_pkg.adder_trans_xagent import *

if __name__ == "__main__":

    def receive_sequence(message):
        sequence = adder_trans(message)
        print("python receive sequence",sequence.a,sequence.b)
        
    agent = Agent("","adder_trans",receive_sequence)
    
    agent.run(100)

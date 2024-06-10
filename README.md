# Network Selection Simulation in 6G Vehicular Enviroment   
In this simulation a network selection model is proposed to select the most appropriate access point when an autonomous vehicle navigates in the environment. The environment is designed in MATLAB incorporating the new aerial access networks introduced by the 6th generation. 

The simulation is crated in MATLAB and uses fuzzy logic for the final decision making. It simulates vehicles entering,navigating and exiting a predetermined enviroment consisitng of 5G gNB nodes and UAV nodes. While navigating the vehicles will perdorm handovers for point to point. So the first step is the Network Selection to find the nodes to which the vehicle is able to handover

For the final decision the FuzzyLogicDesigner module is used and returns the nodes that the vehicle will perform handover.

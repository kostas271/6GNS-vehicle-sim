from pickle import TRUE
import numpy as np
import matplotlib.pyplot as plt

# Define area dimensions
a = 15000  # in meters
b = 15000  # in meters
area = a * b  # in square meters

# Base station topology
r1 = np.array([0, 125, 250, 375, 500, 625, 750, 875, 1000, 1125, 1250, 1375, 1500, 1625,1750])  # x-coordinate
r2 = np.array([0, 0, 0, 0, 0, 0, 0, 22, 22, 22, 22, 22, 22, 22, 22])  # y-coordinate
h_bs = 15  # height of base station in meters
bs_xy = np.column_stack((r1, r2))  # base station coordinates
bs_id = np.arange(1, len(bs_xy) + 1)  # base station IDs

# User equipment topology
h_ue = 1.5  # height of user equipment in meters
ue_xy = np.zeros((1,2))  # user equipment coordinates
ue_id = np.zeros(1)  # user equipment IDs

# UAV station topology
r5 = np.array([0, 500, 1000, 1500])  # x-coordinate
r6 = np.array([10.8, 10.8, 10.8, 10.8])  # y-coordinate
h_ua = 80  # height of UAV in meters
ua_xy = np.column_stack((r5, r6))  # UAV coordinates
ua_id = np.arange(1, len(ua_xy) + 1)  # UAV IDs

# Plot topology
plt.figure(1)
plt.scatter(r1, r2, marker='^', color='r', label='Base Station')  # base station topology
plt.scatter(r5, r6, marker='^', color='b', label='UAV Station')  # UAV station topology
plt.legend()
plt.show()

# Assign resource blocks to user equipment (empty initially)
ue_rb = np.zeros(1)

# Assign random resource blocks to base stations
bs_rb = np.zeros((len(bs_xy), 2))
for j in range(len(bs_rb)):
    bs_rb[j, 0] = bs_id[j]
    bs_rb[j, 1] = np.random.randint(0, 101)

print('The resource blocks of each base station are:')
print(bs_rb)

# Assign random resource blocks to UAV stations
ua_rb = np.zeros((len(ua_xy), 2))
for j in range(len(ua_rb)):
    ua_rb[j, 0] = ua_id[j]
    ua_rb[j, 1] = np.random.randint(0, 101)

print('The resource blocks of each UAV station are:')
print(ua_rb)

# Transmission parameters
Tx_tp = 38
Tx_cl = 2
Tx_ag = 18

# User equipment sensitivity
ue_sensitivity = -45

# Current network condition
net_con = np.zeros((1, len(bs_xy)))

# Current link budget
link_bud = np.zeros((1, len(bs_xy)))

counter = 0

# Matrix A
A = np.zeros((1, len(bs_xy)))

# Matrix B
B = bs_rb[:, 1]

np.random.poisson##

def calc_rithmos_metadosis



# Flag to end the simulation
Sim_Flag = True
# Running time (simulation)
Time = 0
# Execution counter for Event5
K = 1.5
N = 10
# List of events to be executed
Event_List = np.array([
    [1, 0, 0, 0, 0, 0],
    [3, 0, 0, 0, 0, 0],
    [1, 1.5, 0, 0, 0, 0],
    [1, 3, 0, 0, 0, 0]
])

def linear_motion(ue_xy, Time):
    u = 27.7778 * Time  # m/s, equivalent to 100 km/h
    ue_xy_mov = np.copy(ue_xy)
    ue_xy_mov[:, 0] = ue_xy_mov[:, 0] + u
    ue_xy_mov[:, 1] = ue_xy_mov[:, 1]
    return ue_xy_mov

def calc_link_budget(ue_xy, bs_xy, h_ue, h_bs, Tx_tp, Tx_ag, Tx_cl):
    # Find 2D distance from UE to base station
    d2D = np.zeros((ue_xy.shape[0], bs_xy.shape[0]))
  
    
    for i in range(ue_xy.shape[0]):
        for j in range(bs_xy.shape[0]):
            d2D[i, j] = np.sqrt((ue_xy[i, 0] - bs_xy[j, 0]) ** 2 + (ue_xy[i, 1] - bs_xy[j, 1]) ** 2)
    
    # Find 3D distance from UE to base station and UAV
    d3D = np.zeros((ue_xy.shape[0], bs_xy.shape[0]))
    
    for i in range(ue_xy.shape[0]):
        for j in range(bs_xy.shape[0]):
            d3D[i, j] = np.sqrt((ue_xy[i, 0] - bs_xy[j, 0]) ** 2 + (ue_xy[i, 1] - bs_xy[j, 1]) ** 2 + (h_ue - h_bs) ** 2)
    
    # Calculate path loss
    w = 3.55
    c = 3 * 10**8
    dbp1 = 4 * h_bs * h_ue * (w * 10**9 / c)
    
    PL1 = 28 + 22 * np.log10(d3D) + 20 * np.log10(w)
    PL2 = 40 * np.log10(d3D) + 28 + 20 * np.log10(w) - 9 * np.log10(dbp1**2 + (h_bs - h_ue)**2)
   
    PLLOS = np.zeros_like(d3D)
    
    for i in range(ue_xy.shape[0]):
        for j in range(d2D.shape[1]):
            if d2D[i, j] < dbp1:
                PLLOS[i, j] = PL1[i, j]
            else:
                PLLOS[i, j] = PL2[i, j]   
    

    return PLLOS

def Car_enter(Time, Event_List,K, N, ue_xy, ue_id, ue_rb):
    # Print event and time
    print('Car enter')
    print('Time:' + str(Time))

    
    # First car entry
    if Time == 0:
        ue_xy[0, 0] = 0
        ue_xy[0, 1] = 1.8
        vehicle = 1
        ue_id[0] = vehicle
        ue_rb[0] = np.random.randint(5, 25)
    else:  
        if (len(ue_xy)<5):
            vehicle = ue_id[-1] + 1
            new_vehicle=[[0,1.8]]
            ue_xy=np.append(ue_xy,new_vehicle,axis=0)
            ue_id=np.append(ue_id,vehicle)
            ue_rb=np.append(ue_rb,np.random.randint(5, 25))
        else:
            input("Max amount of vehicles in the system, press Enter to continue...")

    print(ue_xy)
    input("Press Enter to continue...")

    #Repeat Event1 with period K
    new_event = [1, Time + 1.5, 0, 0, 0, 0]
    Event_List = np.vstack([Event_List, new_event])
    
    return Event_List,ue_xy, ue_id, ue_rb

def Car_exit(Time, Event_List,vehicle, ue_xy, ue_id, ue_rb):
    # Print event and time
    print('Car exit for vehicle' + str(vehicle+1))
    print('Time:' + str(Time))
    
    print(ue_xy)

    vehicle=int(vehicle)
    # Update vehicle data,edo eimaste
    ue_xy=np.delete(ue_xy,vehicle,0)
    ue_id=np.delete(ue_id,vehicle)
    ue_rb=np.delete(ue_rb,vehicle)
    print('Updated ue_xy:', ue_xy)
    input("Press Enter to continue...")

    
    
    
    return Event_List, ue_xy, ue_id, ue_rb


def update_link_bud(Time, Event_List, ue_xy, ue_id, ue_rb, bs_xy, h_ue, h_bs, Tx_tp, Tx_ag, Tx_cl, bs_rb, ua_rb, counter):
    # Print event and time
    print('update link budget for all vehicles')
    print('Time:' + str(Time))
    
    Link_bud_bs = calc_link_budget(ue_xy, bs_xy, h_ue, h_bs, Tx_tp, Tx_ag, Tx_cl)
    print(Link_bud_bs)
    
    # Update vehicle position
    ue_xy = linear_motion(ue_xy, Time + 1)

    #check if vehicle is exiting system##### prepei na ginei o elegxos prin vgei
    for i in range(ue_xy.shape[0]):
            if (ue_xy[i,0]>=1750):
                new_event = [2, Time, i, 0,0,0]
                Event_List = np.vstack([Event_List, new_event])

    
    # Update event list
    new_event = [3, Time + 1, 0, 0, 0, 0]
    Event_List = np.vstack([Event_List, new_event])
    
    return Event_List, Link_bud_bs, ue_xy

def check_handover():

    return TRUE


# ................................................................................................
# Main simulation loop
while Sim_Flag:

    # Next event to be executed
    Event = Event_List[0, 0]
    # Time of the next event to be executed
    Time = Event_List[0, 1]
    # Vehicle for which the event is intended
    vehicle = Event_List[0, 2]

    # Call different routines depending on the current event
    if Event == 1:
        Event_List,ue_xy, ue_id, ue_rb = Car_enter(
            Time, Event_List,K, N, ue_xy, ue_id, ue_rb
        )
    elif Event == 2:
        Event_List, ue_xy, ue_id, ue_rb = Car_exit(
            Time, Event_List,vehicle, ue_xy, ue_id, ue_rb
        )
    elif Event == 3:
       Event_List, Link_bud_bs, ue_xy = update_link_bud(
            Time, Event_List, ue_xy, ue_id, ue_rb, bs_xy, h_ue, h_bs, Tx_tp, Tx_ag, Tx_cl, bs_rb, ua_rb, counter
        )
    elif Event == 4:
        check_handover()
    
    # ................................................................................................
    # Sort event list to execute the correct event
    Event_List = Event_List[1:]  # Remove the executed event
    Event_List = Event_List[Event_List[:, 1].argsort(kind='mergesort')]  # Sort by time and then by vehicle
    # ................................................................................................





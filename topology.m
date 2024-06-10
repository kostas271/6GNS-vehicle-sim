clear all
close all
clc
%area
a=15000; %in m
b=15000; %in m
area=a*b; %in m2

%base station topology
r1=[0;250;500;750;1000;1250;1500;125;375;625;875;1125;1375;1625]; %for x - coordinate (x,y)
r2=[0;0;0;0;0;0;0;22;22;22;22;22;22;22]; %for y - coordinate (x,y)
h_bs=15; %for BS h (integer)  %in m
bs_xy=cat(2,r1,r2); % base station coordinates
for i=1:size(bs_xy,1)
    bs_id(i)=i;
end

%user equipment topology
%r3=[650]; %for x - coordinate (x,y)
%r4=[5.4]; %for y - coordinate (x,y)
h_ue=1.5; %for UE h  %in m
ue_xy=[]; % user equipment coordinates
ue_id=[];
%for i=1:size(ue_xy,1)
%    ue_id(i)=i;
%end

%uav station topology 
r5=[875;1750;2625;3450]; %for x - coordinate (x,y)
r6=[10.8;10.8;10.8;10.8]; %for y - coordinate (x,y)
h_ua=80; %for BS h (integer)  %in m
ua_xy=cat(2,r5,r6); % base station coordinates
for i=1:size(ua_xy,1)
    ua_id(i)=i;
end


figure (1) %topology
scatter(r1,r2,'^','r') %plot base station topology
hold on
%scatter(r3,r4,'*','r') %plot user equipment topology
%hold on
scatter(r5,r6,'^','b') %plot uav station topology
hold on

%%assign required resource block to ue
ue_rb=[];
ue_rb_temp=[];
%for j=1:size(ue_xy,1)
%ue_rb(j,:)=randi([20 100]); %random assigmed applications to UEs
%end

%disp('The resource blocks of each vehicle are:')
%ue_rb

%assign randomly resource blocks to base stations
bs_rb=zeros(size(bs_xy,1),2);
for j=1:size(bs_rb,1)
bs_rb(j,1)=bs_id(j);
bs_rb(j,2)=randi([0 100]);%random assigmed applications to UEs
end

disp('The resource blocks of each base station are:')
bs_rb

%assign randomly resource blocks to uav base station
ua_rb=zeros(size(ua_xy,1),2);
for j=1:size(ua_rb,1)
ua_rb(j,1)=bs_id(j);
ua_rb(j,2)=randi([0 100]);%random assigmed applications to UEs
end

disp('The resource blocks of each uav station are:')
ua_rb

Tx_tp=38;
Tx_cl=2;
Tx_ag=18;

%user equipment sensitivity
ue_sensitivity=-45;

%current network condition
net_con=zeros(1,size(bs_xy,1))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%start of simulation%%%%%%%%%%%%



%%Arxikopoihsh metablhtvn:
  %Shmaia gia na teleivsei h prosomoivsh:
  Sim_Flag = true;
  %Trexontas xronos (prosomoivshs):
  Time = 0;
  %Metrhths ektelesevn tou Event5:
  K=1.5;
  N=10;
  %Lista gegonotvn pou prokeitai na ektelestoun:
  Event_List = [1,0,0,0,0,0;1,1.5,0,0,0,0];

  %................................................................................................
  

   %................................................................................................
  %Kyrios broxos prosomoivshs:
  while Sim_Flag
      
    
    %Epomeno pros ektelesh gegonos:
    Event=Event_List(1,1);
    %Xronos epomenou gegonotos pros ektelesh:
    Time=Event_List(1,2);
    %oxima gia to opoio prokeitai to event
    vehicle=Event_List(1,3);
    %output probability apo to proigoumeno handover
    prob=Event_List(1,4);
    %resource block pou pire apo kathe base station h apo ena uav
    rb=Event_List(1,5);
    %base stations or uav station
    station=Event_List(1,6);


    
    %Klhsh diaforetikhs routinas analoga me to trexon gegonos:
    if Event==1
   %   Execution_Counter(1,1)+1;
    %  Execution_Times(Time+1,1)=Time;
      [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb]=Car_enter(Time,Event_List,net_con,K,N,ue_xy,ue_id,ue_rb,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ua_id,ua_rb);
    elseif Event==2
     % Execution_Counter(1,2)+1;
      %Execution_Times(Time+1,2)=Time;
      [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb]=Car_exit(Time,Event_List,net_con,vehicle,ue_xy,ue_id,ue_rb,bs_rb,ua_rb,prob,rb,station);
    elseif Event==3
    %  Execution_Counter(1,3)+1;
    %  Execution_Times(Time+1,3)=Time;
      [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb] = Car_network_selection(Time,Event_List,net_con,N,vehicle,ue_xy,ue_id,ue_rb,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ua_id,ua_rb,prob,rb,station);
    elseif Event==4
    %  Execution_Counter(1,4)+1;
    %  Execution_Times(Time+1,4)=Time;
      [Event_List]=calculate(Time,Event_List,r,q);
    end
    %................................................................................................
    
    
    %................................................................................................
    %Taksinomhsh pinaka gia na ektelesei to gegonos pou prepei:
    Event_List(1,:)=[];
    Event_List=(sortrows(Event_List,[2,3]));
    %................................................................................................
  end


%................................................................................................
%Routines:
%Synarthsh:
function [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb]=Car_enter(Time,Event_List,net_con,K,N,ue_xy,ue_id,ue_rb,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ua_id,ua_rb)
  
%Typvsh 'Event1' kai rologiou:
  sprintf('Car enter')
  sprintf('Time: %02d',Time)

  %first car entry
  if(Time==0)
      ue_xy(1,1)=125;
      ue_xy(1,2)=1.8;
      vehicle=1
      ue_id(1)=vehicle;
      ue_rb(1)=randi([5 25]);
  %regular car entry
  else
  ue_xy(end+1,:)=[125 1.8];
  vehicle=ue_id(end)+1
  ue_id(end+1)=vehicle;
  ue_rb(end+1)=randi([5 25]);
  net_con(end+1,:)=0;
  end

  
  [output_propability,final_bs_lb_rb,rb,ua_lb_2,net_con]=calc_link_budget(vehicle,net_con,ue_xy,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ue_rb,ua_id,ua_rb);
  
   %handover event
   Event_List(end+1,1)=3;
   %random time for next handover event;
   L=randi([2,5])
   Event_List(end,2)=Time+L;
   Event_List(end,3)=vehicle;
   
disp('The connection probability is:')
if output_propability<1.5
    disp('going to connect to gNB')
    for(i=1:size(final_bs_lb_rb,1))
        bs_rb(final_bs_lb_rb(i,1),2)=bs_rb(final_bs_lb_rb(i,1),2)-rb;
    end
    Event_List(end,4)=output_propability;
    Event_List(end,5)=rb;
    Event_List(end,6)=final_bs_lb_rb(1,1);
elseif output_propability>1.5 && output_propability<2.5
    disp('going to connect to uav')
    
    ua_lb_2_sorted = sortrows(ua_lb_2,3,'descend');
    
    ua_rb(ua_lb_2_sorted(1,1),2)=ua_rb(ua_lb_2_sorted(1,1),2)-ue_rb(vehicle);

    Event_List(end,4)=output_propability;
    Event_List(end,5)=ue_rb(vehicle);
    Event_List(end,6)=ua_lb_2_sorted(1,1);
else
    disp('v2v')
end

  
  %Epanalhpsh tou Event1, me periodo K:
  %Event_List(end+1,1)=1;
  %Event_List(end,2)=Time+K;
  %Event_List(end,3)=1;
  

   
end

%Synarthsh ylopoihshs tou gegonotos me id = 2:
function [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb]=Car_exit(Time,Event_List,net_con,vehicle,ue_xy,ue_id,ue_rb,bs_rb,ua_rb,prob,rb,station)
  %Typvsh 'Event2' kai rologiou:
  
  sprintf('Car exit')
  vehicle
  ue_rb(vehicle);
  sprintf('Time: %02d',Time)
  ue_xy(vehicle,:)="";
  ue_id(vehicle)="";
  ue_rb(vehicle)="";
  ue_xy

if prob<1.5
    disp('was connected to gNB before exit')
    bs_rb(station,2)=bs_rb(station,2)+rb;
    net_con(vehicle,:)=0;


    

elseif prob>1.5 && prob<2.5
    disp('was connected to uav before exit')
    ua_rb(station,2)=ua_rb(station,2)+rb;
    
else
    disp('v2v')
end

end

%Synarthsh ylopoihshs tou gegonotos me id = 3:
function [Event_List,net_con,ue_xy,ue_id,ue_rb,bs_rb,ua_rb]= Car_network_selection(Time,Event_List,net_con,N,vehicle,ue_xy,ue_id,ue_rb,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ua_id,ua_rb,prob,rb,station)
  %Typvsh 'Event3' kai rologiou:
  sprintf('Car handover')
  vehicle
  sprintf('Time: %02d',Time)

  ue_xy=linear_motion(ue_xy,vehicle,Time);
  
  
  if prob>0 && prob<1.5
    disp('was connected to gNB before handover')
    bs_rb(station,2)=bs_rb(station,2)+rb;
    net_con(vehicle,:)=0;

    

  elseif prob>1.5 && prob<2.5
    disp('was connected to uav before handover')   
    ua_rb(station,2)=ua_rb(station,2)+rb;
    
  end

  %random time for next handover event
  L=randi([2,5]);

   %check if vehicle is not exiting system, handover event
   if ue_xy(vehicle,1)+27.7778*L<1625
    %Epanalhpsh tou Event3:
    Event_List(end+1,1)=3;
    Event_List(end,2)=Time+L;
    Event_List(end,3)=vehicle;

    %if vehicle is exiting system, call exit event
   else
    % Event2:
    Event_List(end+1,1)=2;
    Event_List(end,2)=Time+(1625-ue_xy(vehicle,1))/27.7778;
    Event_List(end,3)=vehicle;
   end

  net_con(vehicle,:)=0;
  [output_propability,final_bs_lb_rb,rb,ua_lb_2,net_con]=calc_link_budget(vehicle,net_con,ue_xy,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ue_rb,ua_id,ua_rb);
    

  disp('The connection probability is:')
if output_propability<1.5
    disp('going to connect to gNB')
    
    for(i=1:size(final_bs_lb_rb,1))
        bs_rb(final_bs_lb_rb(i,1),2)=bs_rb(final_bs_lb_rb(i,1),2)-rb;
    end
    Event_List(end,4)=output_propability;
    Event_List(end,5)=rb;
    Event_List(end,6)=final_bs_lb_rb(1,1);
elseif output_propability>1.5 && output_propability<2.5
    disp('going to connect to uav')
    
    ua_lb_2_sorted = sortrows(ua_lb_2,3,'descend');
    
    ua_rb(ua_lb_2_sorted(1,1),2)=ua_rb(ua_lb_2_sorted(1,1),2)-ue_rb(vehicle);
    
    Event_List(end,4)=output_propability;
    Event_List(end,5)=ue_rb(vehicle);
    Event_List(end,6)=ua_lb_2_sorted(1,1);
else
    disp('v2v')
end

end

%Synarthsh ylopoihshs tou gegonotos me id = 4:
function [Event_List]=caclulate(Time,Event_List,r)
  %Typvsh 'Event4' kai rologiou:
  sprintf('Event4')
  sprintf('Time: %02d',Time)
 
    Event_List(1,end+1)=4;
    Event_List(2,end)=Time+r;
    Event_List(3,end)=1;
end 


%%%calculate rb on entry and leave
function[Event_List,net_con,ue_rb]=calc_rb(Time,Event_List,net_con,vehicle,ue_xy,ue_rb)
  %Typvsh 'Event4' kai rologiou:
 sprintf('calc rb');
 sprintf('Time: %02d',Time);

         ue_rb_temp(vehicle)=ue_rb(vehicle)*0.25;
  

end

%.....................................................


%linear motion
function [ue_xy_mov]=linear_motion(ue_xy,vehicle,Time,ue_id)
u=27.7778*Time; %m/s %100 km/h
ue_xy_mov=ue_xy;
ue_xy_mov(vehicle,1)=ue_xy_mov(vehicle,1)+u;
ue_xy_mov(vehicle,2)=ue_xy_mov(vehicle,2);
%scatter(ue_xy_mov(:,1),ue_xy_mov(:,2),'*','g') %plot user equipment topology
end


function[output_propability,final_bs_lb_rb,rb,ua_lb_2,net_con]=calc_link_budget(vehicle,net_con,ue_xy,bs_xy,ua_xy,h_ue,h_bs,h_ua,Tx_tp,Tx_ag,Tx_cl,ue_sensitivity,bs_id,bs_rb,ue_rb,ua_id,ua_rb)

%%%dfind 2d disance from ue to base station and uav
d2D=zeros(1,size(bs_xy,1));
d2D_ua=zeros(1,size(ua_xy,1));
    for j=1:size(bs_xy,1)
        d2D(1,j)=sqrt((ue_xy(vehicle,1)-bs_xy(j,1))^2+(ue_xy(vehicle,2)-bs_xy(j,2))^2);   %d2D in m
    end
    for z=1:size(ua_xy,1)
        d2D_ua(1,z)=sqrt((ue_xy(vehicle,1)-ua_xy(z,1))^2+(ue_xy(vehicle,2)-ua_xy(z,2))^2);   %d2D_ua in m
    end


%%%dfind 3d disance from ue to base station and uav
d3D=zeros(1,size(bs_xy,1));
d3D_ua=zeros(1,size(ua_xy,1));

    for j=1:size(bs_xy,1)
        d3D(1,j)=sqrt((ue_xy(vehicle,1)-bs_xy(j,1))^2+(ue_xy(vehicle,2)-bs_xy(j,2))^2+(h_ue-h_bs)^2);   %d3D in m
    end
    for z=1:size(ua_xy,1)
        d3D_ua(1,z)=sqrt((ue_xy(vehicle,1)-ua_xy(z,1))^2+(ue_xy(vehicle,2)-ua_xy(z,2))^2+(h_ue-h_ua)^2);   %d3D_ua in m
    end




%------PLLOS-------%
w=3.55;
c=3;
dbp1=4*(h_bs)*(h_ue)*(w*10^9/c*10^8);
dbp2=4*(h_ua)*(h_ue)*(w*10^9/c*10^8);
PL1=28+22*log10(d3D)+20*log10(w);   %%% (10)
PL2=40*log10(d3D)+28+20*log10(w)-9*log10(dbp1^2+(h_bs-h_ue)^2); %%% (11)
PL1_ua=8+22*log10(d3D_ua)+20*log10(w);
PL2_ua=40*log10(d3D_ua)+28+20*log10(w)-9*log10(dbp2^2+(h_ua-h_ue)^2); %%% (11)


    for (j=1:size(d2D,2))
        if d2D(1,j)<dbp1 %%% (9)
                 PLLOS(1,j)=PL1(1,j);
            else PLLOS(1,j)=PL2(1,j);
        end
    end
    for (j=1:size(d2D_ua,2))
        if d2D_ua(1,j)<dbp2  %%%(9)
            PLLOS_ua(1,j)=PL1_ua(1,j);
            else PLLOS_ua(1,j)=PL2_ua(1,j);
        end
    end

Link_bud_bs=Tx_tp+Tx_ag-Tx_cl-PLLOS;
Link_bud_ua=Tx_tp+Tx_ag-Tx_cl-PLLOS_ua;

%%check which base station link budget is lower than ue's sensitivity
bs_lb=[];
    for(j=1:size(Link_bud_bs,2))
        if(Link_bud_bs(1,j)>ue_sensitivity)
            bs_lb(end+1,:)=[bs_id(j) Link_bud_bs(1,j)];
        end
    end

    
disp('The base station that have enough link budget are:')
bs_lb

bs_lb_rb=[];

%find which base station dont have zero resource blocks
for(i=1:size(bs_lb,1))
     if(bs_rb(bs_lb(i,1),2)>0)
            bs_lb_rb(end+1,:)=[bs_lb(i,1) bs_lb(i,2), bs_rb(bs_lb(i,1),2)];
    end
end
     



%calculate divided rb of ue%%%%%%%%%%%%%%%%%%%%%%
final_bs_lb_rb=[];
rb=round(ue_rb(vehicle)/size(bs_lb_rb,1));
remaining=0;

%find base stations that have enough resource blocks
for(i=1:size(bs_lb_rb,1))
    if(bs_lb_rb(i,3)>=rb)
        final_bs_lb_rb(end+1,:)=[bs_lb_rb(i,1) bs_lb_rb(i,2) bs_lb_rb(i,3)];
    else

    end
end
   

disp('The base station that have enough resource blocks are:')
final_bs_lb_rb

%%update network condtions
for(i=1:size(final_bs_lb_rb,1))
    net_con(vehicle,final_bs_lb_rb(i,1))=rb;
end

net_con

ua_lb=[];

%%check if uav station link budget is lower than ue's sensitivity
    for(j=1:size(Link_bud_ua,2))
        if(Link_bud_ua(1,j)>ue_sensitivity)
            ua_lb(end+1,:)=[ua_id(j) Link_bud_ua(1,j)];
        end
    end

disp('The uav station that have enough link budget are:')
ua_lb

ua_lb_2=[];
%find which uav station have the required resource blocks
for(i=1:size(ua_lb,1))
    if(ua_rb(ua_lb(i,1),2)>ue_rb(vehicle))
        ua_lb_2(end+1,:)=[ua_lb(i,1) ua_lb(i,2) ua_rb(ua_lb(i,1),2)];
    end
end

disp('The uav station that have enough resource blocks are:')
ua_lb_2


vehicles_report=[size(final_bs_lb_rb,1),size(final_bs_lb_rb,1),size(ua_lb_2,1),size(ua_lb_2,1)];
output_propability=zeros(size(vehicles_report,1),1);


fiz=readfis('fuzzy');
for (i=1:size(vehicles_report,1))
    output = evalfis(fiz,vehicles_report(i,:));
    output_propability(i,1)=output;
end

end

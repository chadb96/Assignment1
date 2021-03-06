close all;
clear;

%size of region
xsize= 200e-9;
xstart= 0;
ysize= 100e-9;
ystart= 0;
%positions
i= 1;
j= 1;
initialpos= zeros(50,8);
prevpos= zeros(50,8);

T= 300;
m0= 9.11e-31;
meff= 0.26*m0;
kb= 1.38e-23;
numofelec= 100;
time= 0;
velocity= sqrt((kb*T)/meff);

tmn= 0.2e-12;
pscat= 1-exp(-1e-14/tmn);
velocity2= zeros(1,30);
for i=1:1:20
    j= 1;
    for j=1:1:4
        if(j==1)
            randx= rand(1,1);
            initialpos(i,j)= randx*200e-9; 
        elseif(j==2)
            randy= rand(1,1);
            initialpos(i,j)= randy*100e-9; 
        elseif(j==3)
            randd= rand(1,1);
            initialpos(i,j)= randd*2*pi;
        else
            randvx= randn(1,1);
            randvy= randn(1,1);
            vx= velocity*randvx;
            vy= velocity*randvy;
            vth= sqrt(vx^2+vy^2);
            initialpos(i,j)= vth; 
            velocity2(1,i) = initialpos(i,j);
        end
        j=j+1;  
    end        
    i=i+1;
end
figure(1);
hist(velocity2, 100);
title 'Histogram of Velocities';
xlabel 'Time (s)';
ylabel 'Velocity';
timestep = 1e-14;
finaltime = 1e-12;
totaltime = finaltime/timestep;
T = zeros(1,totaltime);
count = zeros(totaltime);
velocity2= zeros(1,totaltime);
figure(2);

%(j,1) x position
%(j,2) y position
%(j,3) velocity
%(j,4) direction
%Boundary conditions: 
for i =0:timestep:finaltime
      count(1,:)= timestep*2;
    for j=1:1:30
        
        if ((initialpos(j,1)+initialpos(j,2)*timestep)>=xsize)
            initialpos(j,1) = xstart;
            prevpos(j,1) = xstart;
        elseif((initialpos(j,1)+initialpos(j,2)*timestep)<=xstart)
            initialpos(j,1)=xsize;
            prevpos(j,1) = xsize; 
        end
        if((initialpos(j,2)+initialpos(j,1)*timestep)>=ysize)
            initialpos(j,4) = -initialpos(j,4);
            initialpos(j,3) = pi - initialpos(j,3); 
        elseif((initialpos(j,2)+initialpos(j,1)*timestep)<=ystart)
            initialpos(j,4) = -initialpos(j,4);
            initialpos(j,3) = pi - initialpos(j,3); 
        end
        if pscat>rand()
            newrandom= rand(1,1);
            initialpos(j,3)= newrandom*2*pi;
            randvx= randn(1,1);
            vx= velocity*randvx;
            randvy= randn(1,1);
            vy= velocity*randvy;
            vth= sqrt(vx^2+vy^2);
            initialpos(j,4) = vth;
        end
    %getting initial positions
    plot([prevpos(j,1),initialpos(j,1)],[prevpos(j,2),initialpos(j,2)]);
    axis([0 200e-9 0 100e-9]); 
        
    T(1,:) = ((initialpos(j,3)/timestep)*meff)/kb;
        
    end
    prevpos(:,1) = initialpos(:,1);
    prevpos(:,2) = initialpos(:,2);
    %making the x and y components move through time
    initialpos(:,1) = initialpos(:,1) + initialpos(:,4).*cos(initialpos(:,3)).*timestep; %x
    initialpos(:,2) = initialpos(:,2) + initialpos(:,4).*sin(initialpos(:,3)).*timestep; %y
    

title 'Part 2: 2D Trajectories of Electrons with Scatter';
hold on;
pause(0.01);
     
end
 
  
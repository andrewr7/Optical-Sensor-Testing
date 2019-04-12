%Made by Andrew Baird
%Capstone Team 30
%3/9/2019

%The purpose of this script is to collect and plot position and velocity
%data for the optical sensor

%clearing the workspace
clc;
clear;

%open data file and extract the raw data  
DataFileID = fopen('slowfasttest.txt');
RawDataString = fscanf(DataFileID,'%s');

%split txt file into seperate fast and slow data strings
splitpoint = strfind(RawDataString,'FAST:');
rawDataTimeDeletedsf = extractBefore(RawDataString,splitpoint);
rawDataTimeDeletedf = extractAfter(RawDataString, splitpoint);
rawDataTimeDeletedsf = erase(rawDataTimeDeletedsf,'Slow:');
rawDataTimeDeletedf = erase(rawDataTimeDeletedf,'Fast:');

%isolate the position in the data string of each x and y 
dXPosInArraysf = strfind(rawDataTimeDeletedsf,'X:');
dYPosInArraysf = strfind(rawDataTimeDeletedsf,'Y:');
slowarray =1:size(dYPosInArraysf,2);

%extract the change in x per timestep(0.1 second) and also initialize a
%vector to track the overall x position
XposTracksf(1)=0;
 for j=slowarray
        
        dXsf(j) = str2double(extractBetween(rawDataTimeDeletedsf,...
            dXPosInArraysf(j)+2,dYPosInArraysf(j)-1));
        XposTracksf(j+1) = XposTracksf(j)+dXsf(j);
 end
 
%delete the last element so the size of the array matches the other arrays
%for plotting purposes
XposTracksf(end) = [];

%extract the change in y per timestep(0.1 second) and also initialize a
%vector to track the overall y position
YposTracksf(1)=0;
for j=slowarray
        if j==size(dYPosInArraysf,2)
            dYsf(j) = str2double(extractBetween(rawDataTimeDeletedsf,...
                dYPosInArraysf(j)+2,size(rawDataTimeDeletedsf,2)));
        else
            dYsf(j) = str2double(extractBetween(rawDataTimeDeletedsf,...
                dYPosInArraysf(j)+2,dXPosInArraysf(j+1)-1));
        end
        YposTracksf(j+1) = YposTracksf(j)+dYsf(j);
end

%delete the last element so the size of the array matches the other arrays
%for plotting purposes
YposTracksf(end) = [];

%calculate total speed from the x and y velocities and plot it vs time
totalvelocity = (dXsf.^2+dYsf.^2).^0.5;
plot(slowarray,totalvelocity)
title('Overall Speed vs Time 0.1 sec increment')

%Various Figures
figure
plot(slowarray,XposTracksf)
title('X pos vs time slow')
figure
plot(slowarray,YposTracksf)
title('Y pos vs time slow')
figure
plot(XposTracksf, YposTracksf)
title('X pos vs Y pos slow')
axis equal


%create an animates line figure to visualize the motion of the sensor over
%time
figure
h = animatedline;
ylim([min(YposTracksf) max(YposTracksf)])
title('X pos vs Y pos slow animated')
axis equal

for k = slowarray
    addpoints(h,XposTracksf(k),YposTracksf(k));
    drawnow
    pause(0.05)
end

%isolate the position in the data string of each x and y 
dXPosInArrayf = strfind(rawDataTimeDeletedf,'X:');
dYPosInArrayf = strfind(rawDataTimeDeletedf,'Y:');
fastarray = 1:size(dYPosInArrayf,2);

%extract the change in x per timestep(0.1 second) and also initialize a
%vector to track the overall x position
XposTrackf(1)=0;
 for j=fastarray
        
        dXf(j) = str2double(extractBetween(rawDataTimeDeletedf,...
            dXPosInArrayf(j)+2,dYPosInArrayf(j)-1));
        XposTrackf(j+1) = XposTrackf(j)+dXf(j);
 end
 
 %delete the last element so the size of the array matches the other arrays
 %for plotting purposes
 XposTrackf(end) = [];

%extract the change in y per timestep(0.1 second) and also initialize a
%vector to track the overall y position
YposTrackf(1)=0;
for j=fastarray
        if j==size(dYPosInArrayf,2)
            dYf(j) = str2double(extractBetween(rawDataTimeDeletedf,...
                dYPosInArrayf(j)+2,size(rawDataTimeDeletedf,2)));
        else
            dYf(j) = str2double(extractBetween(rawDataTimeDeletedf,...
                dYPosInArrayf(j)+2,dXPosInArrayf(j+1)-1));
        end
        YposTrackf(j+1) = YposTrackf(j)+dYf(j);
end

%delete the last element so the size of the array matches the other arrays
%for plotting purposes
YposTrackf(end) = [];

%Some more fun plots
figure
plot(fastarray,dXf)
title('x vel vs time fast')
figure
plot(fastarray,dYf)
title('y vel vs time fast')
figure
plot(dXf,dYf)
title('x vel vs y vel fast')
axis equal

%calculate total speed from the x and y velocities and plot it vs time
totalvelocity = (dXf.^2+dYf.^2).^0.5;
plot(fastarray,totalvelocity)
title('Overall velocity vs time 0.1 sec increment')


% 

figure
plot(fastarray,XposTrackf)
title('x pos vs time fast')
figure
plot(fastarray,YposTrackf)
title('y pos vs time fast')
figure
plot(XposTrackf, YposTrackf)
title('x pos vs y pos fast')
axis equal


%create an animates line figure to visualize the motion of the sensor over
%time
figure
h = animatedline;
ylim([min(YposTrackf) max(YposTrackf)])
title('x pos vs y pos animated fast')
axis equal

for k = fastarray
    addpoints(h,XposTrackf(k),YposTrackf(k));
    drawnow
    pause(0.05)
end

%correcting data by one order of magnitude
fastarray2 = fastarray./10;
slowarray2 = slowarray./10;

%Plot for Position vs time
figure
plot(slowarray2,YposTracksf)
hold on
plot(fastarray2,YposTrackf)
title('Recorded Y Position vs Time')
xlabel('Time (s)')
ylabel('Position (pixels)')
legend('device moving slow (20 cm in ~11 seconds)',...
    'device moving fast (20 cm in ~2 seconds)','Location','northwest')

%correcting data by one order of magnitude
dYsf2 = dYsf./10;
dYf2 = dYf./10;
slowarray2 = slowarray./10;

%Plot for velocity vs time
figure 
plot(slowarray2,dYsf2)
hold on
plot (fastarray2, mean(dYf2)*ones(size(dYPosInArrayf,2),1),'--')
plot(fastarray2,dYf2)
plot (slowarray2, mean(dYsf2)*ones(size(dYPosInArraysf,2),1),'--')
title('Recorded Velocity Data for Slow and Fast Motion')
legend('device moving slow (20 cm in ~11 seconds)','slow average'...
    ,'device moving fast (20 cm in ~2 seconds)','fast average')
xlabel('Time (s)')
ylabel('Speed Output (pixels/s)')

%Calculating the ratios of recorded fast and slow data
FastSlowRatio_distance = mean(dYf2)/mean(dYsf2)
FastSlowRatio_time = size(dYPosInArraysf,2)/size(dYPosInArrayf,2)

%This ratio should be equal to the fast/slow speed ratio
FastSlowRatio_speed = FastSlowRatio_time/FastSlowRatio_distance


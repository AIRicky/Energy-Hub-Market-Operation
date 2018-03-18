function [Pwav,Pwstd,Pd]= forecast_data(season)

% This function is used to generation the forecast of 24-hour wind power with two 
% parameters:average and standard deviation
% Pwav:  the average hourly wind power generation vector with 24 values
% Pwstd: the standard deviation of the hourly power generation vector with
%         24 values

%% wind power forecast data
Pwr = 1;                            % the rated power of the wind farm(MW)
% the relative value of the average and the st deviation 
R_Pwav = [0.63 0.73 0.79 0.75 0.77 0.51 0.35 0.17 0.09 0.18 0.34 0.4 ...
          0.21 0.39 0.67 0.74 0.76 0.73 0.36 0.31 0.36 0.32 0.42 0.5]*1.25; % Pwav/Pwr
R_Pwstd = 0.02:(0.08-0.02)/23:0.08;  % Pwstd/Pwr    
% 
Pwav = R_Pwav*Pwr;              % the average wind power generation
Pwstd = R_Pwstd*Pwr;            % the standard deviation of wind power generation

% To show the wind power result
figure
plot(Pwav,'* -')
hold on 
plot(Pwstd,'+k-')
% axis([0 25 0 Pwr])

% xlabel('t/h')
% ylabel('Pw')
% the envelope of wind power wind confidence of being 99%,delta = 2.58std
Pwupper = Pwav + 2.58*Pwstd;
Pwlower = Pwav - 2.58*Pwstd;
% figure
plot(Pwupper,'-.r')
% hold on
plot(Pwlower,'-.g')
% hold off
xlabel('t/h')
ylabel('Pw (p.u.)')
legend('Average','Standard Deviation','Upper Bound','Lower Bound')
%% Load data
Pdmax = 1;   % the maximum load demand(MW)
Pd_hour_spring = Pdmax*[63 62 60 58 59 65 72 85 95 99 100 99 93 92 90 88 90 92 96 98 96 90 80 70]/100;  % the one-day hourly load demand in spring and fall(MW)
Pd_hour_summer = Pdmax*[64 60 58 56 56 58 64 76 87 95 99 100 99 100 100 97 96 96 93 92 92 93 87 72]/100; % the one-day hourly load demand in summer(MW)
Pd_hour_winter = Pdmax*[67 63 60 59 59 60 74 86 95 96 96 95 95 95 93 94 99 100 100 96 91 83 73 63]/100; % the one-day hourly load demand in winter(MW)

if (season == 1)||(season==3)
    Pd = Pd_hour_spring;
elseif season ==2
    Pd = Pd_hour_summer;
elseif season ==4
    Pd = Pd_hour_winter;
end
        
% Plot the result
figure
plot(Pd_hour_spring,'* - r')
hold on
plot(Pd_hour_summer,'+ - b')
hold on
plot(Pd_hour_winter, 'o - k')
xlabel('t/h')
ylabel('Pd')
legend('Spring/Autumn', 'Summer','Winter')
% Plot load data starting from 12 in the noon
figure 
plot([Pd_hour_spring(13:end),Pd_hour_spring(1:12)])

%% data for Plug in Electric Vehicles









[HDdata,txt,raw] = xlsread('HeatLoaddata.xlsx'); % MW
Multiplefactor = 1; % load. mag
HDdata(:,2:4) = Multiplefactor*HDdata(:,2:4)*1e3; % summer, spring, fall-winter
switch SeasonD
    case 0 % typical 
         H_factor = sum(heatnode(:,2))/1250; 
         H_hd0 = H_factor*[1250*ones(1,4), 1150*ones(1,4), 1000*ones(1,4), 800*ones(1,4),...
         1150*ones(1,4), 1250*ones(1,4)]; % kW
    case 1 % summer 
        summer = HDdata(:,2); 
        H_factor = sum(heatnode(:,2))/max(summer);
        H_hd0 = H_factor*summer';
    case 2 % spring 
        spring = HDdata(:,3); 
        H_factor = sum(heatnode(:,2))/max(spring);
        H_hd0 = H_factor*spring';
    case 3 % fall-winter
        fallwin = HDdata(:,4); 
        H_factor = sum(heatnode(:,2))/max(fallwin);
        H_hd0 = H_factor*fallwin';
end
H_Hd = H_ratio * H_hd0(1:NT); % kW ? 10/19

figure
subplot(2,1,1)
H_factor = sum(heatnode(:,2))/1250; 
p_H_hd0 = H_factor*[1250*ones(1,4), 1150*ones(1,4), 1000*ones(1,4), 800*ones(1,4),...
         1150*ones(1,4), 1250*ones(1,4)]; % kW
summer = HDdata(:,2); 
H_factor = sum(heatnode(:,2))/max(summer);
p_H_hd1 = H_factor*summer';   
spring = HDdata(:,3); 
H_factor = sum(heatnode(:,2))/max(spring);
p_H_hd2 = H_factor*spring';
fallwin = HDdata(:,4); 
H_factor = sum(heatnode(:,2))/max(fallwin);
p_H_hd3 = H_factor*fallwin';
% plot(1:NT,Sb*p_H_hd0,'-g^')
plot(1:NT,Sb*p_H_hd2,'-bs')
hold on
plot(1:NT,Sb*p_H_hd1,'-r*')
plot(1:NT,Sb*p_H_hd3,'-co')
xlabel('time (h)')
ylabel('heat load (MW))')
hh = legend('spring', 'summer', 'fall-winter');%
% hh.Orientation = 'horizontal';
% legend boxoff

subplot(2,1,2)
% Pd_Season_0 = PFactor*[63 62 60 58 59 65 72 85 95 99 100 99 93 92 90 88 90 92 96 98 96 90 80 70]/15-1.5;  % MW
Pd_Season_1 = PFactor*[63 62 60 58 59 65 72 85 95 99 100 99 93 92 90 88 90 92 96 98 96 90 80 70]/15-1.5; 
Pd_Season_2 = PFactor*[64 60 58 56 56 58 64 76 87 95 99 100 99 100 100 97 96 96 93 92 92 93 87 72]/15-1.5;
Pd_Season_3 = PFactor*[67 63 60 59 59 60 74 86 95 96 96 95 95 95 93 94 99 100 100 96 91 83 73 63]/15-1.5;
plot(1:NT,Pd_Season_1,'-bs')
hold on
plot(1:NT,Pd_Season_2,'-r*')
plot(1:NT,Pd_Season_3,'-co')
xlabel('time (h)')
ylabel('electric load (MW))')
hh = legend('spring-fall', 'summer', 'winter');%
% hh.Orientation = 'horizontal';
% legend boxoff
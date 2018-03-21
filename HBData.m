%%% ============== energy (MW) =======
%% outer variables MW
p_hub_in_max = 2;
p_hub_in_min = 0; 
p_hub_out_max = 1.5; 
p_hub_out_min = 0;
if Option_MPTest_Gas
    p_gasin_max = 1.0
else
    p_gasin_max = 1.5; 
end

% p_gasin_max = 0; 
% p_gasin_max = 0.5; 
p_gasin_min = 0;
h_hub_max = 1.5;
h_hub_min = 0;

% outer variables p.u.
p_hub_in_max = p_hub_in_max/SB;
p_hub_in_min = p_hub_in_min/SB;
p_hub_out_max = p_hub_out_max/SB;
p_hub_out_min = p_hub_out_min/SB;
p_gasin_max = p_gasin_max/SB;
p_gasin_min = p_gasin_min/SB;
h_hub_max = h_hub_max/SB;
h_hub_min = h_hub_min/SB;

% outer variable  price  $/MWh ================
Pr_E_in_min = min(Cgrid/SB);
Pr_E_in_max = max(Cgrid/SB);
Pr_E_out_min = min(Cgrid/SB);
Pr_E_out_max = max(Cgrid/SB);
Pr_E_in_av = mean(Cgrid/SB); 
Pr_E_out_av = mean(Cgrid/SB);

Pr_H_min = 15;
Pr_H_max = 30;
Pr_H_av = 25; % check


% outer variable  price price  p.u. ================
Pr_E_in_min = Pr_E_in_min*SB;
Pr_E_in_max = Pr_E_in_max*SB;
Pr_E_out_min = Pr_E_out_min*SB;
Pr_E_out_max = Pr_E_out_max*SB;
Pr_H_min = Pr_H_min*SB;
Pr_H_max = Pr_H_max*SB;
Pr_E_in_av = Pr_E_in_av*SB;
Pr_E_out_av = Pr_E_out_av*SB;
Pr_H_av = Pr_H_av*SB;

% linearize the bi-linear term 
M = 1000; % check
% G = 255; % segment
G = 127;
K = 6; % BE binary number
delta_Pr_E_out = (Pr_E_out_max - Pr_E_out_min)/G; % p.u.
delta_Pr_E_in = (Pr_E_in_max - Pr_E_in_min)/G; % p.u.
delta_Pr_H = (Pr_H_max - Pr_H_min)/G; % p.u.

%% inner variables MW
E_Hub_l = 0; 
E_Hub_u = 10;
H_Hub_l = 0;  
H_Hub_u = 10;
E_Hub0 = 1; %2  
H_Hub0 = 1; %2
p_char_max = 3;
p_char_min = 0;
p_disc_max = 2;
p_disc_min = 0;
h_char_max = 2;
h_char_min = 0;
h_disc_max = 1.5;
h_disc_min = 0;

% inner variables p.u.
E_Hub_l = E_Hub_l/SB; 
E_Hub_u = E_Hub_u/SB; 
H_Hub_l = H_Hub_l/SB; 
H_Hub_u = H_Hub_u/SB; 
E_Hub0 = E_Hub0/SB;
H_Hub0 = H_Hub0/SB;

p_char_max = p_char_max/SB; 
p_char_min = p_char_min/SB; 
p_disc_max = p_disc_max/SB;
p_disc_min = p_disc_min/SB;
h_char_max = h_char_max/SB;
h_char_min = h_char_min/SB;
h_disc_max = h_disc_max/SB;
h_disc_min = h_disc_min/SB;

% ================ efficiency ================
yita_tf = 1; % no transformer
yita_chp_E = 0.35; % check
yita_chp_H = 0.65; % check
switch Option_Eff 
    case 1
        yita_ees = sqrt(0.98);
        yita_tes = sqrt(0.98);
    case 2
        yita_ees = sqrt(0.80);
        yita_tes = sqrt(0.98);
    case 3
        yita_ees = sqrt(0.60);
        yita_tes = sqrt(0.98);
    case 4
        yita_ees = sqrt(0.98);
        yita_tes = sqrt(0.80);
    case 5
        yita_ees = sqrt(0.98);
        yita_tes = sqrt(0.60);
    case 6
        yita_ees = sqrt(0.80);
        yita_tes = sqrt(0.80);
    case 7
        yita_ees = sqrt(0.60);
        yita_tes = sqrt(0.60);
end

yita_hp = 3;


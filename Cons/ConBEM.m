% BEM_Base = 2.^linspace(0,7,8); 
BEM_Base = 2.^linspace(0,6,7); 
F_BEM_P = [];
F_BEM_P = [F_BEM_P, (Pr_E_out == Pr_E_out_min + delta_Pr_E_out*(BEM_Base*x_E_out)):'BEM_Pr_E_out 1'];
F_BEM_P = [F_BEM_P, (0 <= repmat(p_hub_out,K+1,1) - z_E_out <= M*(1-x_E_out)):'BEM_P_out 2'];
F_BEM_P = [F_BEM_P, (0 <= z_E_out <= M*x_E_out):'BEM_P_out 3'];
% F_BEM_P = [F_BEM_P, (0 <= repmat(p_hub_out,K+1,1) - z_E_out <= Pr_E_out_max*(1-x_E_out)):'BEM_P_out 2'];
% F_BEM_P = [F_BEM_P, (0 <= z_E_out <= Pr_E_out_max*x_E_out):'BEM_P_out 3'];

F_BEM_P = [F_BEM_P, (Pr_E_in == Pr_E_in_min + delta_Pr_E_in*(BEM_Base*x_E_in)):'BEM_P_in 1'];
F_BEM_P = [F_BEM_P, (0 <= repmat(p_hub_in,K+1,1) - z_E_in <= M*(1-x_E_in)):'BEM_P_in 2']; 
F_BEM_P = [F_BEM_P, (0 <= z_E_in <= M*x_E_in):'BEM_P_in 3'];
% F_BEM_P = [F_BEM_P, (0 <= repmat(p_hub_in,K+1,1) - z_E_in <= Pr_E_in_max*(1-x_E_in)):'BEM_P_in 2']; 
% F_BEM_P = [F_BEM_P, (0 <= z_E_in <= Pr_E_in_max*x_E_in):'BEM_P_in 3'];

F_BEM_H = [];
F_BEM_H = [F_BEM_H, (Pr_H == Pr_H_min + delta_Pr_H*(BEM_Base*x_H)):'BEM_H 1'];  % necessary
F_BEM_H = [F_BEM_H, (0 <= repmat(h_hub,K+1,1) - z_H <= M*(1-x_H)):'BEM_H 2']; 
F_BEM_H = [F_BEM_H, (0 <= z_H <= M*x_H):'BEM_H 3']; 
% F_BEM_H = [F_BEM_H, (0 <= repmat(h_hub,K+1,1) - z_H <= Pr_H_max*(1-x_H)):'BEM_H 2']; 
% F_BEM_H = [F_BEM_H, (0 <= z_H <= Pr_H_max*x_H):'BEM_H 3']; 
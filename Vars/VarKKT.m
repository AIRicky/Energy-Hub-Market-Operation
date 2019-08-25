% variable - PDN
lambda_E = sdpvar(N_Bus,NT);
lambda_Q = sdpvar(N_Bus,NT);
lambda_U = sdpvar(N_Bus,NT);
miu_hub_out_under = sdpvar(N_Bus,NT);
miu_hub_out_bar = sdpvar(N_Bus,NT);
miu_hub_in_under = sdpvar(N_Bus,NT);
miu_hub_in_bar = sdpvar(N_Bus,NT);
miu_U_under = sdpvar(N_Bus,NT);
miu_U_bar = sdpvar(N_Bus,NT);
miu_pg_under = sdpvar(N_Bus,NT);
miu_pg_bar = sdpvar(N_Bus,NT);
miu_qg_under = sdpvar(N_Bus,NT);
miu_qg_bar = sdpvar(N_Bus,NT);
miu_c_under = sdpvar(N_Bus,NT); % add 10/05
miu_c_bar = sdpvar(N_Bus,NT); % add 10/05
miu_hp_under = sdpvar(N_Bus,NT);
miu_hp_bar = sdpvar(N_Bus,NT);
miu_W_under = sdpvar(N_Bus,NT);
miu_W_bar = sdpvar(N_Bus,NT);
% miu_grid_under = sdpvar(1,NT);
% miu_grid_bar = sdpvar(1,NT);

% variable - DHN
%  ======  $/p.u. =========   
lambda_H = sdpvar(1,NT); 
lambda_GB = sdpvar(N_Node,NT); 
lambda_hub = sdpvar(N_Node,NT);
lambda_d = sdpvar(N_Node,NT); 
lambda_hp = sdpvar(N_Node,NT); 

lambda_Sm = sdpvar(N_Node,NT);
lambda_Rm = sdpvar(N_Node,NT);
lambda_R_in = sdpvar(N_Pipe,NT);
lambda_S_in = sdpvar(N_Pipe,NT);
lambda_R_out = sdpvar(N_Pipe,NT);
lambda_S_out = sdpvar(N_Pipe,NT);
rho_S_under = sdpvar(N_Node,NT);
rho_S_bar = sdpvar(N_Node,NT);
rho_R_under = sdpvar(N_Node,NT);
rho_R_bar = sdpvar(N_Node,NT);
rho_hub_under = sdpvar(N_Node,NT);
rho_hub_bar = sdpvar(N_Node,NT);
rho_hp_under = sdpvar(N_Node,NT);
rho_hp_bar = sdpvar(N_Node,NT);
rho_GB_under = sdpvar(N_Node,NT);
rho_GB_bar = sdpvar(N_Node,NT);
% rho_hd_under = sdpvar(N_Node,NT);
% rho_hd_bar = sdpvar(N_Node,NT);

% Initilize 
F_Init_P = [];
for i = 1 : N_Bus
    if  i ~= DataPDN.IndGT
        F_Init_P = [F_Init_P,miu_pg_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_pg_bar(i,:) == 0];
        F_Init_P = [F_Init_P,miu_qg_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_qg_bar(i,:) == 0]; 
    end
    if i ~= DataPDN.IndGenW
        F_Init_P = [F_Init_P,miu_W_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_W_bar(i,:) == 0];
    end
    if i ~= DataPDN.IndEH
        F_Init_P = [F_Init_P,miu_hub_out_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_hub_out_bar(i,:) == 0];
        F_Init_P = [F_Init_P,miu_hub_in_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_hub_in_bar(i,:) == 0]; 
    end
    if i ~= DataPDN.IndSVG
        F_Init_P = [F_Init_P,miu_c_under(i,:) == 0];
        F_Init_P = [F_Init_P,miu_c_bar(i,:) == 0]; 
    end
end

% Initilize 
F_Init_H = [];
for i = 1:N_Node
    if i ~= DataDHN.IndEH
        F_Init_H = [F_Init_H, rho_hub_under(i,:) == 0];
        F_Init_H = [F_Init_H, rho_hub_bar(i,:) == 0];
    end
    if i ~= DataDHN.IndHP
        F_Init_H = [F_Init_H, rho_hp_under(i,:) == 0];
        F_Init_H = [F_Init_H, rho_hp_bar(i,:) == 0];
    end
    if i ~= DataDHN.IndGB
        F_Init_H = [F_Init_H, rho_GB_under(i,:) == 0];
        F_Init_H = [F_Init_H, rho_GB_bar(i,:) == 0];
    end
%     if i ~= DataDHN.IndHd
%         F_Init_H = [F_Init_H, rho_hd_under(i,:) == 0];
%         F_Init_H = [F_Init_H, rho_hd_bar(i,:) == 0];
%     end
end

F_Init = [F_Init_P, F_Init_H];
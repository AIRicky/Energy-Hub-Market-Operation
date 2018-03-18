F_Inter_UL_P = [];  % between up & lower level
F_Inter_UL_D = [];
F_Inter_UL_P = [F_Inter_UL_P, (0 <= p_hub_in <= p_hat_hub_in):'P_in_Bid_Limit']; 
F_Inter_UL_P = [F_Inter_UL_P, (0 <= p_hub_out <= p_hat_hub_out):'P_out_Bid_Limit']; 
F_Inter_UL_D = [F_Inter_UL_D, (0 <= h_hub <= h_hat_hub):'H_Bid_Limit'];

F_Inter_PH_P = []; % between two network 
F_Inter_PH_H = []; % between two network 
F_Inter_PH_P = [F_Inter_PH_P, (Pg_EH_in(DataPDN.IndEH,:) == p_hub_in):'Inter_P_Hub_in']; 
F_Inter_PH_P = [F_Inter_PH_P, (Pg_EH_out(DataPDN.IndEH,:) == p_hub_out):'Inter_P_Hub_out']; 
F_Inter_PH_H = [F_Inter_PH_H, (Hg_EH(DataDHN.IndEH,:) == h_hub):'Inter_H_Hub']; 



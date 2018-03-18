F_PF_Hub = [];
F_PF_Hub = [F_PF_Hub, uhub_char + uhub_disc <= 1];
F_PF_Hub = [F_PF_Hub, (ue_char + ue_disc <= 1):'Hub_ESS_char/disc'];
F_PF_Hub = [F_PF_Hub, (uh_char + uh_disc <= 1):'Hub_TES_char/disc'];

F_PF_Hub = [F_PF_Hub, (E_Hub_l <= E_Hub <= E_Hub_u):'Hub_E_Bound'];
F_PF_Hub = [F_PF_Hub, (H_Hub_l <= H_Hub <= H_Hub_u):'Hub_H_Bound'];


% F_PF_Hub = [F_PF_Hub, (Pr_E_in_min <= Pr_E_in <= Pr_E_in_max):'Pr_E_in_limit1'];
% F_PF_Hub = [F_PF_Hub, (sum(Pr_E_in) <= NT*Pr_E_in_av):'Pr_E_in_limit2'];
% F_PF_Hub = [F_PF_Hub, (Cgrid <= Pr_E_out):'Pr_E_out_limit1']
% F_PF_Hub = [F_PF_Hub, Pr_E_out >= Pr_E_in]; % 11/10
% F_PF_Hub = [F_PF_Hub, (Sb*LMP_base <= Pr_E_out):'Pr_E_out_limit1']
% F_PF_Hub = [F_PF_Hub, (sum(Pr_E_out) <= NT*Pr_E_out_av):'Pr_E_out_limit2'];


F_PF_Hub = [F_PF_Hub, (p_gasin_min <= p_gasin <= p_gasin_max):'Gas_In_Bound']; 
F_PF_Hub = [F_PF_Hub, (p_in1*yita_tf + p_gasin*yita_chp_E + p_disc == p_hub_out + p_char):'Hub_P_Balance1'];
F_PF_Hub = [F_PF_Hub, (p_in2*yita_hp + p_gasin*yita_chp_H + h_disc == h_char + h_hub):'Hub_H_Balance'];
F_PF_Hub = [F_PF_Hub, (p_hub_in == p_in1 + p_in2):'Hub_P_Balance2'];

F_PF_Hub = [F_PF_Hub, (p_disc_min*ue_disc <= p_disc <= p_disc_max*ue_disc):'P_disc_Bound'];
F_PF_Hub = [F_PF_Hub, (p_char_min*ue_char <= p_char <= p_char_max*ue_char):'P_char_Bound'];
F_PF_Hub = [F_PF_Hub, (h_disc_min*uh_disc <= h_disc <= h_disc_max*uh_disc):'H_disc_Bound'];
F_PF_Hub = [F_PF_Hub, (h_char_min*uh_char <= h_char <= h_char_max*uh_char):'H_char_Bound'];

F_PF_Hub = [F_PF_Hub, (E_Hub(1,1) == E_Hub0 + p_char(1,1) - p_disc(1,1)/yita_ees):'ESS_SOC_1'];
F_PF_Hub = [F_PF_Hub, (E_Hub(1,2:NT) == E_Hub(1,1:NT-1) + p_char(1,2:NT) - p_disc(1,2:NT)/yita_ees):'ESS_SOC_2'];
F_PF_Hub = [F_PF_Hub, (E_Hub(1,NT) == E_Hub0):'ESS_SOC_3'];

F_PF_Hub = [F_PF_Hub, (H_Hub(1,1) == H_Hub0 + h_char(1,1) - h_disc(1,1)/yita_tes):'TES_SOC_1'];
F_PF_Hub = [F_PF_Hub, (H_Hub(1,2:NT) == H_Hub(1,1:NT-1) + h_char(1,2:NT) - h_disc(1,2:NT)/yita_tes):'TES_SOC_2'];
F_PF_Hub = [F_PF_Hub, (H_Hub(1,NT) == H_Hub0):'TES_SOC_3'];


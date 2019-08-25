% variable
uh_char = binvar(1,NT);
uh_disc = binvar(1,NT);
ue_char = binvar(1,NT);
ue_disc = binvar(1,NT);
p_gasin = sdpvar(1,NT);
p_in1 = sdpvar(1,NT);
p_in2 = sdpvar(1,NT);
p_char = sdpvar(1,NT);
p_disc = sdpvar(1,NT);
h_char = sdpvar(1,NT);
h_disc = sdpvar(1,NT);
p_hub_in = sdpvar(1,NT);
p_hub_out = sdpvar(1,NT);
h_hub = sdpvar(1,NT);
p_hat_hub_in = sdpvar(1,NT);
p_hat_hub_out = sdpvar(1,NT);
h_hat_hub = sdpvar(1,NT);
E_Hub = sdpvar(1,NT);
H_Hub = sdpvar(1,NT);
lambda_E_hat_hub_in = sdpvar(1,NT); % price bid
lambda_E_hat_hub_out = sdpvar(1,NT); % price bid
lambda_H_hat_out = sdpvar(1,NT); % price bid

% Binary expansion variables
x_E_out = binvar(K+1,NT);
x_E_in = binvar(K+1,NT);
x_H = binvar(K+1,NT);
z_E_out = sdpvar(K+1,NT);
z_E_in = sdpvar(K+1,NT);
z_H =  sdpvar(K+1,NT);

% constraint
F_Hub = [];
F_Hub = [F_Hub, ue_char + ue_disc <= 1];
F_Hub = [F_Hub, uh_char + uh_disc <= 1];
F_Hub = [F_Hub, E_Hub_l <= E_Hub <= E_Hub_u];
F_Hub = [F_Hub, H_Hub_l <= H_Hub <= H_Hub_u];
F_Hub = [F_Hub, 0 <= h_hat_hub <= h_hub_max];
F_Hub = [F_Hub, 0 <= p_hat_hub_in <= p_hub_in_max];
F_Hub = [F_Hub, 0 <= p_hat_hub_out <= p_hub_out_max];
F_Hub = [F_Hub, p_in1*yita_tf + p_gasin*yita_chp_E + p_disc == p_hub_out + p_char];
F_Hub = [F_Hub, p_in2*yita_hp + p_gasin*yita_chp_H + h_disc == h_char + h_hub];
F_Hub = [F_Hub, p_hub_in == p_in1 + p_in2];
F_Hub = [F_Hub, 0 <= p_disc <= p_disc_max*ue_disc];
F_Hub = [F_Hub, 0 <= p_char <= p_char_max*ue_char];
F_Hub = [F_Hub, 0 <= h_disc <= h_disc_max*uh_disc];
F_Hub = [F_Hub, 0 <= h_char <= h_char_max*uh_char];
F_Hub = [F_Hub, E_Hub(1,1) == E_Hub0 + p_char(1,1) - p_disc(1,1)/yita_ees];
F_Hub = [F_Hub, E_Hub(1,2:NT) == E_Hub(1,1:NT-1) + p_char(1,2:NT) - p_disc(1,2:NT)/yita_ees];
F_Hub = [F_Hub, E_Hub(1,NT) == E_Hub0];
F_Hub = [F_Hub, H_Hub(1,1) == H_Hub0 + h_char(1,1) - h_disc(1,1)/yita_tes];
F_Hub = [F_Hub, H_Hub(1,2:NT) == H_Hub(1,1:NT-1) + h_char(1,2:NT) - h_disc(1,2:NT)/yita_tes];
F_Hub = [F_Hub, H_Hub(1,NT) == H_Hub0];

% binary expansion
BEM_Base = 2.^linspace(0,7,8); 
F_BEM = [];
F_BEM = [F_BEM, p_hub_out == p_hub_out_min + delta_p_hub_out*(BEM_Base*z_E_out)];
F_BEM = [F_BEM, repmat(lambda_E(Ind_EH_PDN,:),K+1,1) - z_E_out <= M*(1-x_E_out)]; % Ind_EH 
F_BEM = [F_BEM, 0 <= z_E_out <= M*x_E_out];
F_BEM = [F_BEM, p_hub_in == p_hub_in_min + delta_p_hub_in*(BEM_Base*z_E_in)];
F_BEM = [F_BEM, repmat(lambda_E(Ind_EH_PDN,:),K+1,1) - z_E_in <= M*(1-x_E_in)]; % lambda_E(Ind_EH,:)
F_BEM = [F_BEM, 0 <= z_E_in <= M*x_E_in];
F_BEM = [F_BEM, h_hub == h_hub_min + delta_h_hub*(BEM_Base*z_H)];
F_BEM = [F_BEM, repmat(lambda_H,K+1,1) - z_H <= M*(1-x_H)]; % lambda_H
F_BEM = [F_BEM, 0 <= z_H <= M*x_H];
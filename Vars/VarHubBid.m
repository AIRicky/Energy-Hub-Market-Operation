% ===============  (offer) price bid  $/p.u. ===============
Pr_E_out = sdpvar(1,NT);
Pr_E_in = sdpvar(1,NT); 
Pr_H = sdpvar(1,NT);

% ===============  (offer) quantity bid p.u. ===============
p_hat_hub_out = sdpvar(1,NT); 
p_hat_hub_in = sdpvar(1,NT); 
h_hat_hub = sdpvar(1,NT);


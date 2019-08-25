% =================== p.u. =================
p_hub_out = sdpvar(1,NT); 
p_hub_in = sdpvar(1,NT); 
h_hub = sdpvar(1,NT);

p_gasin = sdpvar(1,NT); 
p_in1 = sdpvar(1,NT);  p_in2 = sdpvar(1,NT);
p_char = sdpvar(1,NT); p_disc = sdpvar(1,NT);
h_char = sdpvar(1,NT); h_disc = sdpvar(1,NT);
E_Hub = sdpvar(1,NT);
H_Hub = sdpvar(1,NT);

% ============= char/disc  ================
uh_char = binvar(1,NT);   uh_disc = binvar(1,NT);
ue_char = binvar(1,NT);   ue_disc = binvar(1,NT);
uhub_char = binvar(1,NT); uhub_disc = binvar(1,NT);

% =============== Binary expansion ===================
x_E_out = binvar(K+1,NT,'full'); % k 0-> K
x_E_in = binvar(K+1,NT,'full');
x_H = binvar(K+1,NT,'full');
z_E_out = sdpvar(K+1,NT,'full'); % p.u.
z_E_in = sdpvar(K+1,NT,'full');
z_H =  sdpvar(K+1,NT,'full'); % p.u.
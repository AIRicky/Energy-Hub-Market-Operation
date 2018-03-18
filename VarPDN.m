% ============= p.u. ================= 
P = sdpvar(N_line,NT,'full'); 
Q = sdpvar(N_line,NT,'full'); 
Psub = sdpvar(N_line,NT,'full'); 
Qsub = sdpvar(N_line,NT,'full'); 
U2 = sdpvar(N_Bus,NT,'full'); 
Pg_GT = sdpvar(N_Bus,NT,'full'); 
Pg_EH_in = sdpvar(N_Bus,NT,'full');
Pg_EH_out = sdpvar(N_Bus,NT,'full');
Qg_GT= sdpvar(N_Bus,NT,'full'); 
Qg_SVG = sdpvar(N_Bus,NT,'full');
Pgrid = sdpvar(1,NT); 
Qgrid = sdpvar(1,NT); 
% Wg = sdpvar(N_Bus,NT,'full');


% ============= p.u. ================= 
tao_PS_F = sdpvar(N_Pipe,NT,'full');% in
tao_PS_T = sdpvar(N_Pipe,NT,'full');% out   
tao_PR_F = sdpvar(N_Pipe,NT,'full');% in 
tao_PR_T = sdpvar(N_Pipe,NT,'full');% out  
tao_NS = sdpvar(N_Node,NT,'full');% nodal 
tao_NR = sdpvar(N_Node,NT,'full');% nodal
Hg_GB = sdpvar(N_Node,NT,'full'); % GB
Hg_EH = sdpvar(N_Node,NT,'full'); % EH
% H_Phai = sdpvar(1,NT); % heat loss 


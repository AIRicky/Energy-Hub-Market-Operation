% ==========Tranported power and heat loss ============
psai = zeros(N_Pipe,1); % pipe loss factor
Phai = zeros(N_Pipe,NT); % Transfered heat power
Q_LossS = zeros(N_Pipe,NT); % Supply pipe heat loss
Q_LossR = zeros(N_Pipe,NT); % Return pipe heat loss
tao_am = 15; % ambient
tao_am = tao_am/Taob; % p.u.
psai = exp(-lamada_pipe.*L_pipe./(cp*ms_pipe));
% R_tao_NS = reshape(x_kkt_DHN(getvariables(tao_NS)-recoverymodel_DHN.used_variables(1) + 1),N_Node,NT);
% R_tao_NR = reshape(x_kkt_DHN(getvariables(tao_NR)-recoverymodel_DHN.used_variables(1) + 1),N_Node,NT);
% R_tao_NS = tao_NS
Phai = cp*repmat(ms_pipe,1,NT).*((value(tao_NS(pipe(:,2),:)-tao_am))-repmat(psai,1,NT).*(value(tao_NR(pipe(:,3),:)-tao_am)));
Q_LossS = cp*repmat(ms_pipe,1,NT).*(value(tao_NS(pipe(:,2),:)-tao_am)).*(1-repmat(psai,1,NT));
Q_LossR = cp*repmat(ms_pipe,1,NT).*(value(tao_NR(pipe(:,3),:)-tao_am)).*(1-repmat(psai,1,NT));

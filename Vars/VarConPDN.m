P = sdpvar(N_line,NT,'full'); 
Q = sdpvar(N_line,NT,'full'); 
Psub = sdpvar(N_line,NT,'full'); 
Qsub = sdpvar(N_line,NT,'full'); 
U2 = sdpvar(N_bus,NT,'full'); % Square of bus voltage amp.
Pg_GT = sdpvar(N_bus,NT,'full'); % Injected P to each bus 
Qg_GT= sdpvar(N_bus,NT,'full'); % Injected Q to each bus
Qg_SVG = sdpvar(N_bus,NT,'full'); % SVG
Pgrid = sdpvar(1,NT); % P from grid
Qgrid = sdpvar(1,NT); % Q from grid
Wg = sdpvar(N_bus,NT,'full'); % Wind Gen 

%% ConPDN
F_P = [];
F_Q = []; 
F_U = [];
for i = 1:N_bus 
    if isempty(find(IndGenW == i)) % Equip wind gen? No
        F_P = [F_P, Wg(i,1:NT) == 0];
    end
    if isempty(find(IndGT == i)) % Equip GT? No
        F_P = [F_P, Pg_GT(i,1:NT) == 0];
        F_Q = [F_Q, Qg_GT(i,1:NT) == 0];
    end
    if isempty(find(IndSVG ==i)) % Equip SVG? % No
        F_Q = [F_Q, Qg_SVG(i,1:NT) == 0];
    end
%     if isempty(find(Ind_EHP_PDN == i)) % Equip EHP? % No
%         F_P = [F_P, Pg_EHP(i,1:NT) == 0];
%     end
%     if isempty(find(Ind_CSP_PDN == i)) % Equip EHP? % No
%         F_P = [F_P, Pg_Hub(i,1:NT) == 0];
%     end
end
Ind_subline = zeros(N_line,2); % Index of Children line of PDN  
for i = 1: N_line
    temp = find(line_i == line_j(i));
    if  ~isempty(temp)
        Ind_subline(i,1:length(temp)) = temp;
    end
end
for t = 1:NT  % PQ through subline
    for i = 1:N_line
        num_temp = size(find(Ind_subline(i,:) == 0),2);
        if num_temp == 1               
            F_P = [F_P, Psub(i,t) == P(Ind_subline(i,1),t)];
            F_Q = [F_Q, Qsub(i,t) == Q(Ind_subline(i,1),t)];
        elseif num_temp == 2
            F_P = [F_P, Psub(i,t) == 0];
            F_Q = [F_Q, Qsub(i,t) == 0];
        else
            F_P = [F_P, Psub(i,t) == P(Ind_subline(i,1),t) + P(Ind_subline(i,2),t)];
            F_Q = [F_Q, Qsub(i,t) == Q(Ind_subline(i,1),t) + Q(Ind_subline(i,2),t)];
        end
    end
end

F_P = [F_P, P(1,:) == Pgrid(1,:)]; 
F_Q = [F_Q, Q(1,:) == Qgrid(1,:)]; 
F_P = [F_P, Pgrid >= 0];
F_P = [F_P, P >= 0];
F_Q = [F_Q, Q >= 0];
F_Q = [F_Q, Qgrid >= 0];
F_U = [F_U, U2(1,:) == 1.05^2];
Vs1 = 1.05^2*ones(1,NT); 

F_P = [F_P, (P(1:N_line,:) + Pg_GT(line_j(1:N_line),:) + Wg(line_j(1:N_line),:) == Psub(1:N_line,:) + Pd(line_j(1:N_line),:)):'testP'];
% F_P = [F_P, (P(1:N_line,:) + Pg_GT(line_j(1:N_line),:) + Pg_Hub(line_j(1:N_line),:) + Wg(line_j(1:N_line),:) ...
%     == Psub(1:N_line,:) + Pd(line_j(1:N_line),:) + Pg_EHP(line_j(1:N_line),:)):'testP'];
F_Q = [F_Q, Q(1:N_line,:) + Qg_GT(line_j(1:N_line),:) + Qg_SVG(line_j(1:N_line),:) == Qsub(1:N_line,:) + Qd(line_j(1:N_line),:)];
F_U = [F_U, U2(line_j(1:N_line),:) == U2(line_i(1:N_line),:)-(diag(r(1:N_line))*P(1:N_line,:)+diag(x(1:N_line))*Q(1:N_line,:))/Vs1(1,1)];
F_P = [F_P, Pg_GT_l <= Pg_GT <= Pg_GT_u];
F_P = [F_P, Wg_l <= Wg <= Wg_u];
% F_P = [F_P, Hg_EHP_l/EHP_yita <= Pg_EHP <= Hg_EHP_u/EHP_yita];
F_Q = [F_Q, Qg_GT_l <= Qg_GT <= Qg_GT_u];
F_Q = [F_Q, Qg_SVG_l <= Qg_SVG <= Qg_SVG_u];
F_U = [F_U, U2_l <= U2 <= U2_u];
F_PDN = [F_P,F_Q,F_U];
F_P = [];
F_Q = []; 
F_U = [];

F_Init_Gen_P = [];
for i = 1:N_Bus 
    if i ~= IndGT 
        F_Init_Gen_P = [F_Init_Gen_P, (Pg_GT(i,1:NT) == 0):['Init_Gen_P GT_P' num2str(i)]];
        F_Init_Gen_P = [F_Init_Gen_P, (Qg_GT(i,1:NT) == 0):['Init_Gen_P GT_Q' num2str(i)]];
    end
    if i ~= IndSVG
        F_Init_Gen_P = [F_Init_Gen_P, (Qg_SVG(i,1:NT) == 0):['Init_Gen_P SVG' num2str(i)]];
    end
    if  i ~= DataPDN.IndEH
        F_Init_Gen_P = [F_Init_Gen_P, (Pg_EH_in(i,:) == 0):['Init_Gen_P EH_In' num2str(i)]];
        F_Init_Gen_P = [F_Init_Gen_P, (Pg_EH_out(i,:) == 0):['Init_Gen_P EH_Out' num2str(i)]];
    end
%     if  i ~= DataPDN.IndHP
%         F_Init_Gen_P = [F_Init_Gen_P, (Pg_EHP(i,:) == 0):['Init_Gen_P EHP' num2str(i)]];
%     end
%     if i ~= IndGenW
%         F_Init_Gen_P = [F_Init_Gen_P, (Wg(i,1:NT) == 0):['Init_Gen_P W' num2str(i)]];
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
            F_P = [F_P, (Psub(i,t) == P(Ind_subline(i,1),t)):['P_Sub', num2str(i)]];
            F_Q = [F_Q, (Qsub(i,t) == Q(Ind_subline(i,1),t)):['Q_Sub', num2str(i)]];
        elseif num_temp == 2
            F_P = [F_P, (Psub(i,t) == 0):['P_Sub', num2str(i)]];
            F_Q = [F_Q, (Qsub(i,t) == 0):['Q_Sub', num2str(i)]];
        else
            F_P = [F_P, (Psub(i,t) == P(Ind_subline(i,1),t) + P(Ind_subline(i,2),t)):['P_Sub', num2str(i)]];
            F_Q = [F_Q, (Qsub(i,t) == Q(Ind_subline(i,1),t) + Q(Ind_subline(i,2),t)):['Q_Sub', num2str(i)]];
        end
    end
end

F_P = [F_P, (P(1,:) == Pgrid(1,:)):'P_Grid']; 
F_Q = [F_Q, (Q(1,:) == Qgrid(1,:)):'Q_Grid']; 
F_P = [F_P, Pgrid <= Pgrid_max]; 
F_P = [F_P, Qgrid <= Qgrid_max]; 
F_P = [F_P, (P >= 0):'P_NonNeg'];
F_Q = [F_Q, (Q >= 0):'Q_NonNeg'];
F_U = [F_U, (U2(1,:) == 1.05^2):'U_Root'];
Vs1 = 1.05^2*ones(1,NT); 

F_P = [F_P, (P(1:N_line,:) + Pg_GT(line_j(1:N_line),:) + Pg_EH_out(line_j(1:N_line),:) == Psub(1:N_line,:) ...
      + Pd(line_j(1:N_line),:) + Pg_EH_in(line_j(1:N_line),:)):'DualPDN_P'];
F_Q = [F_Q, (Q(1:N_line,:) + Qg_GT(line_j(1:N_line),:) + Qg_SVG(line_j(1:N_line),:) == Qsub(1:N_line,:) + Qd(line_j(1:N_line),:)):'DualPDN_Q'];
F_U = [F_U, (U2(line_j(1:N_line),:) == U2(line_i(1:N_line),:)-(diag(r(1:N_line))*P(1:N_line,:)+diag(x(1:N_line))*Q(1:N_line,:))/Vs1(1,1)):'PDN_U'];
F_P = [F_P, (Pg_GT_l <= Pg_GT <= Pg_GT_u):'P_GT_Bound'];
% F_P = [F_P, (Wg_l <= Wg <= Wg_u):'P_W_Bound'];
F_Q = [F_Q, (Qg_GT_l <= Qg_GT <= Qg_GT_u):'Q_GT_Bound'];
F_Q = [F_Q, (Qg_SVG_l <= Qg_SVG <= Qg_SVG_u):'Q_SVG_Bound'];
F_U = [F_U, (U2_l <= U2 <= U2_u):'U_Bound'];
F_PF_PDN = [F_Init_Gen_P, F_P,F_Q,F_U];
S_pipe_F = zeros(N_Node,4);
S_pipe_T = zeros(N_Node,4);

F_Init_Gen_H = [];
for i = 1:N_Node
    if i ~= DataDHN.IndGB
        F_Init_Gen_H = [F_Init_Gen_H, (Hg_GB(i,:) == 0):['Init_Gen_H_GB' num2str(i)]];
    end
    if i ~= DataDHN.IndEH
        F_Init_Gen_H = [F_Init_Gen_H, (Hg_EH(i,:) == 0):['Init_Gen_H_EH' num2str(i)]];
    end
%     if i ~= DataDHN.IndHP
%         F_Init_Gen_H = [F_Init_Gen_H, (Hg_HP(i,:) == 0):['Init_Gen_H_HP' num2str(i)]];
%     end
end

F_H = [];
F_H = [F_H, (Hg_GB(DataDHN.IndGB,1:NT) == cp*repmat(m_Hs(DataDHN.IndGB)',1,NT).*...
      (tao_NS(DataDHN.IndGB,1:NT) - tao_NR(DataDHN.IndGB,1:NT))):'GB'];
F_H = [F_H, (Hg_EH(DataDHN.IndEH,1:NT) == cp*repmat(m_Hs(DataDHN.IndEH)',1,NT).*...
      (tao_NS(DataDHN.IndEH,1:NT) - tao_NR(DataDHN.IndEH,1:NT))):'EH'];
F_H = [F_H, (H_Hd(DataDHN.IndHd,1:NT) == cp*repmat(m_Hd(DataDHN.IndHd),1,NT).*...
      (tao_NS(DataDHN.IndHd,1:NT)-tao_NR(DataDHN.IndHd,1:NT))):'Hd'];
F_H = [F_H, (0 <= Hg_GB(DataDHN.IndGB,1:NT) <= Hg_GB_max(DataDHN.IndGB,1:NT)):'GB_Bound'];
%F_H = [F_H, (sum(Hg_GB(DataDHN.IndGB,1:NT))+Hg_EH(DataDHN.IndEH,1:NT) == sum(H_Hd(DataDHN.IndHd,1:NT)) + H_Phai):'MHP'];
for j = 1:N_Node
    F_H = [F_H, (tao_NS_min(j) <= tao_NS(j,:) <= tao_NS_max(j)):'Tao_S_Bound'];
    F_H = [F_H, (tao_NR_min(j) <= tao_NR(j,:) <= tao_NR_max(j)):'Tao_R_Bound'];
end

F_PH = [];
for i = 1:N_Node
    temp1 = find(pipe_i == i); % pipe with node i as 'from' 
    temp2 = find(pipe_j == i); % pipe with node i as 'to'
    S_pipe_F(i,1:length(temp1)) = temp1; % set of pipe with i as 'from' 
    S_pipe_T(i,1:length(temp2)) = temp2; % set of pipe with i as 'to'
end

Sum_mbR = zeros(N_Node,1); 
Sum_mbS = zeros(N_Node,1);

for i = 1:N_Node % supply pipe temp. mixture equation 
     num_temp1 = size(find(S_pipe_T(i,:) == 0),2); % num. of pipe with i as 'to' 
    if num_temp1 == 0  % 4
        b = S_pipe_T(i,1:4); % pipe incide 
        Sum_mbS(i) = sum(ms_pipe(b(1:4)));
        F_PH = [F_PH, (sum(repmat(ms_pipe(b(1:4)),1,NT).*tao_PS_T(b(1:4),:))...
                == Sum_mbS(i)*tao_NS(i,:)):['Tao_Mix_S', num2str(i)]];
        F_PH = [F_PH, (tao_PR_F(b([1:4]),:) == repmat(tao_NR(i,:),4,1)):['Tao_Pipe_R_In', num2str(i)]];
    end
    if num_temp1 == 1  % 3
        b = S_pipe_T(i,1:3); % pipe indice 
        Sum_mbS(i) = sum(ms_pipe(b(1:3)));
        F_PH = [F_PH, (sum(repmat(ms_pipe(b(1:3)),1,NT).*tao_PS_T(b(1:3),:))...
               == Sum_mbS(i)*tao_NS(i,:)):['Tao_Mix_S', num2str(i)]];
        F_PH = [F_PH, (tao_PR_F(b([1:3]),:) == repmat(tao_NR(i,:),3,1)):['Tao_Pipe_R_In', num2str(i)]];
    end
    if  num_temp1 == 2  % 2
        b = S_pipe_T(i,1:2); % pipe indice
        Sum_mbS(i) = sum(ms_pipe(b(1:2)));
        F_PH = [F_PH, (sum(repmat(ms_pipe(b(1:2)),1,NT).*tao_PS_T(b(1:2),:))...
               == Sum_mbS(i)*tao_NS(i,:)):['Tao_Mix_S', num2str(i)]];
        F_PH = [F_PH, (tao_PR_F(b([1:2]),:) == repmat(tao_NR(i,:),2,1)):['Tao_Pipe_R_In', num2str(i)]];
    end
    if  num_temp1 == 3  % 1
        b = S_pipe_T(i,1); % pipe indice 
        Sum_mbS(i) = ms_pipe(b(1));
        F_PH = [F_PH, (ms_pipe(b(1))* tao_PS_T(b(1),:) == ms_pipe(b(1)) * tao_NS(i,:)):['Tao_Mix_S', num2str(i)]];
        F_PH = [F_PH, (tao_PR_F(b(1),:) == repmat(tao_NR(i,:),1,1)):['Tao_Pipe_R_In', num2str(i)]];
    end

    num_temp2 = size(find(S_pipe_F(i,:) == 0),2); % return pipe temp. mix. equation
    if num_temp2 == 0  % 4
        b = S_pipe_F(i,1:4);
        Sum_mbR(i) = sum(mr_pipe(b(1:4)));
        F_PH = [F_PH, (sum(repmat(mr_pipe(b(1:4)),1,NT).*tao_PR_T(b(1:4),:))...
               == Sum_mbR(i)*tao_NR(i,:)):['Tao_Mix_R', num2str(i)]];
        F_PH = [F_PH, (tao_PS_F(b([1:4]),:) == repmat(tao_NS(i,:),4,1)):['Tao_Pipe_S_In', num2str(i)]];
    end
    if num_temp2 == 1  % 3
        b = S_pipe_F(i,1:3);
        Sum_mbR(i) = sum(mr_pipe(b(1:3)));
        F_PH = [F_PH, (sum(repmat(mr_pipe(b(1:3)),1,NT).*tao_PR_T(b(1:3),:))...
               == Sum_mbR(i)*tao_NR(i,:)):['Tao_Mix_R', num2str(i)]];
        F_PH = [F_PH, (tao_PS_F(b([1:3]),:) == repmat(tao_NS(i,:),3,1)):['Tao_Pipe_S_In', num2str(i)]];
    end
    if num_temp2 == 2  % 2
        b = S_pipe_F(i,1:2);
        Sum_mbR(i) = sum(mr_pipe(b(1:2)));
        F_PH = [F_PH, (sum(repmat(mr_pipe(b(1:2)),1,NT).*tao_PR_T(b(1:2),:))...
               == Sum_mbR(i)*tao_NR(i,:)):['Tao_Mix_R', num2str(i)]];
        F_PH = [F_PH, (tao_PS_F(b([1:2]),:) == repmat(tao_NS(i,:),2,1)):['Tao_Pipe_S_In', num2str(i)]];
    end
    if num_temp2 == 3  % 1
        b = S_pipe_F(i,1); 
        Sum_mbR(i) = mr_pipe(b(1));
        F_PH = [F_PH, (mr_pipe(b(1))* tao_PR_T(b(1),:) ==  Sum_mbR(i) * tao_NR(i,:)):['Tao_Mix_R', num2str(i)]];
        F_PH = [F_PH, (tao_PS_F(b(1),:) == repmat(tao_NS(i,:),1,1)):['Tao_Pipe_S_In', num2str(i)]];
    end
end

tao_am = 15;
tao_am = tao_am/Taob; % p.u.
tao_K = 273.15; 
tao_K = tao_K/Taob; % p.u.

for i = 1:N_Pipe % temp. drop. 
    F_PH = [F_PH, tao_PS_T(i,:) - (tao_am)*ones(1,NT) == (tao_PS_F(i,:) - (tao_am)*ones(1,NT))*exp(-lamada_pipe(i)*L_pipe(i)/(cp*ms_pipe(i)*Mb))]; % change as psai(i) p.u. ?
    F_PH = [F_PH, tao_PR_T(i,:) - (tao_am)*ones(1,NT) == (tao_PR_F(i,:) - (tao_am)*ones(1,NT))*exp(-lamada_pipe(i)*L_pipe(i)/(cp*mr_pipe(i)*Mb))]; % change as psai(i) p.u.?
%     F_PH = [F_PH, (tao_PS_T(i,:) - (tao_am-tao_K) == (tao_PS_F(i,:) - (tao_am-tao_K))*psai(i)):['Pipe_Heat_Loss_S', num2str(i)]]; % psai(i) is p.u.
%     F_PH = [F_PH, (tao_PR_T(i,:) - (tao_am-tao_K) == (tao_PR_F(i,:) - (tao_am-tao_K))*psai(i)):['Pipe_Heat_Loss_R', num2str(i)]]; % psai(i) is p.u.
end
F_PF_DHN = [F_H,F_PH,F_Init_Gen_H];
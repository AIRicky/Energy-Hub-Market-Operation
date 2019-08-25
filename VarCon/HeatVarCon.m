% VarDHN
tao_PS_F = sdpvar(N_pipe,NT,'full'); %'From' side temp. of supply 
tao_PS_T = sdpvar(N_pipe,NT,'full'); %'To' side 
tao_PR_F = sdpvar(N_pipe,NT,'full'); %'From' side temp. of return
tao_PR_T = sdpvar(N_pipe,NT,'full'); %'To' side 
tao_NS = sdpvar(N_node,NT,'full');   % Node temp. of supply
tao_NR = sdpvar(N_node,NT,'full');   % Node temp. of return
Hg_HP = sdpvar(N_node,NT,'full');    % Heat source of DHN;

S_pipe_F = zeros(N_node,4);
S_pipe_T = zeros(N_node,4);
% ConDHN
F_H = [];
for i = 1:N_node
    if isempty(find(Nd_Hs == i))
        F_H = [F_H, Hg_HP(i,:)==0]; % non-heat source
    end
end
F_H = [F_H,(Hg_HP(1:N_node,1:NT)==cp*repmat(m_Hs(1:N_node)',1,NT).*...
      (tao_NS(1:N_node,1:NT)-tao_NR(1:N_node,1:NT))):'Source'];
F_H = [F_H,(H_Hd(1:N_node,1:NT)==cp*repmat(m_Hd(1:N_node),1,NT).*...
      (tao_NS(1:N_node,1:NT)-tao_NR(1:N_node,1:NT))):'Load'];
F_H = [F_H, Hg_HP(Nd_Hs,1:NT) <= repmat(heatgen(:,2),1,NT)]; % upper bound 
for j = 1:N_node
    F_H = [F_H, tao_NS_min(j) <= tao_NS(j,:) <= tao_NS_max(j)];
    F_H = [F_H, tao_NR_min(j) <= tao_NR(j,:) <= tao_NR_max(j)];
end

F_PH = [];
for i = 1:N_node
    temp1 = find(pipe_i == i); % pipe with node i as 'from' 
    temp2 = find(pipe_j == i); % pipe with node i as 'to'
    S_pipe_F(i,1:length(temp1)) = temp1; % set of pipe with i as 'from' 
    S_pipe_T(i,1:length(temp2)) = temp2; % set of pipe with i as 'to'
end

for i = 1:N_node % supply pipe temp. mixture equation 
     num_temp1 = size(find(S_pipe_T(i,:) == 0),2); % num. of pipe with i as 'to' 
    if num_temp1 == 0  % 4
        b = S_pipe_T(i,1:4); % pipe incide 
        F_PH = [F_PH, sum(repmat(ms_pipe(b(1:4)),1,NT).*tao_PS_T(b(1:4),:))...
                ==sum(ms_pipe(b(1:4)))*tao_NS(i,:)];
        F_PH = [F_PH, tao_PR_F(b([1:4]),:) == repmat(tao_NR(i,:),4,1)];
    end
    if num_temp1 == 1  % 3
        b = S_pipe_T(i,1:3); % pipe indice 
        F_PH = [F_PH, sum(repmat(ms_pipe(b(1:3)),1,NT).*tao_PS_T(b(1:3),:))...
               ==sum(ms_pipe(b(1:3)))*tao_NS(i,:)];
        F_PH = [F_PH, tao_PR_F(b([1:3]),:) == repmat(tao_NR(i,:),3,1)];
    end
    if  num_temp1 == 2  % 2
        b = S_pipe_T(i,1:2); % pipe indice
        F_PH = [F_PH, sum(repmat(ms_pipe(b(1:2)),1,NT).*tao_PS_T(b(1:2),:))...
               ==sum(ms_pipe(b(1:2)))*tao_NS(i,:)];
        F_PH = [F_PH, tao_PR_F(b([1:2]),:) == repmat(tao_NR(i,:),2,1)];
    end
    if  num_temp1 == 3  % 1
        b = S_pipe_T(i,1); % pipe indice 
        F_PH = [F_PH, ms_pipe(b)* tao_PS_T(b,:) == ms_pipe(b) * tao_NS(i,:)];
        F_PH = [F_PH, tao_PR_F(b([1:1]),:) == repmat(tao_NR(i,:),1,1)];
%         F_PH = [F_PH, sum(repmat(ms_pipe(b(1)),1,NT).*tao_PS_T(b(1),:))
%         == sum(ms_pipe(b(1)))*tao_NS(i,:)]; % there is a mistake
    end
    if  num_temp1 == 4  % 0
        pause(1e-10) % no operation
    end
    
    num_temp2 = size(find(S_pipe_F(i,:) == 0),2); % return pipe temp. mix. equation
    if num_temp2 == 0  % 4
        b = S_pipe_F(i,1:4); % indice
        F_PH = [F_PH, sum(repmat(mr_pipe(b(1:4)),1,NT).*tao_PR_T(b(1:4),:))...
               ==sum(mr_pipe(b(1:4)))*tao_NR(i,:)];
        F_PH = [F_PH, tao_PS_F(b([1:4]),:) == repmat(tao_NS(i,:),4,1)];
    end
    if num_temp2 == 1  % 3
        b = S_pipe_F(i,1:3); % indice
        F_PH = [F_PH, sum(repmat(mr_pipe(b(1:3)),1,NT).*tao_PR_T(b(1:3),:))...
               ==sum(mr_pipe(b(1:3)))*tao_NR(i,:)];
        F_PH = [F_PH, tao_PS_F(b([1:3]),:) == repmat(tao_NS(i,:),3,1)];
    end
    if num_temp2 == 2  % 2
        b = S_pipe_F(i,1:2); % indice
        F_PH = [F_PH, sum(repmat(mr_pipe(b(1:2)),1,NT).*tao_PR_T(b(1:2),:))...
               ==sum(mr_pipe(b(1:2)))*tao_NR(i,:)];
        F_PH = [F_PH, tao_PS_F(b([1:2]),:) == repmat(tao_NS(i,:),2,1)];
    end
    if num_temp2 == 3  % 1
        b = S_pipe_F(i,1);  % indice
        F_PH = [F_PH, mr_pipe(b)* tao_PR_T(b,:) == mr_pipe(b) * tao_NR(i,:)];
%         F_PH = [F_PH,
%         sum(repmat(mr_pipe(b(1:1)),1,NT).*tao_PR_T(b(1:1),:)) ==
%         sum(mr_pipe(b(1:1)))*tao_NR(i,:)]; % mistake similar to supply
        F_PH = [F_PH, tao_PS_F(b([1:1]),:) == repmat(tao_NS(i,:),1,1)];
    end
    if num_temp2 == 4  % 0
        pause(1e-10) % no operation
    end
end

tao_am = 15; % ambient
tao_K = 273.15; 
tao_am = tao_am + tao_K; 
for i = 1:N_pipe % temp. drop. 
    F_PH = [F_PH, tao_PS_T(i,:)-(tao_am-tao_K)==(tao_PS_F(i,:)-(tao_am-tao_K)).*...
           exp(-lamada_pipe(i)*L_pipe(i)/(cp*ms_pipe(i)))];
    F_PH = [F_PH, tao_PR_T(i,:)-(tao_am-tao_K)==(tao_PR_F(i,:)-(tao_am-tao_K)).*...
           exp(-lamada_pipe(i)*L_pipe(i)/(cp*mr_pipe(i)))];
end
F_DHN = [F_H,F_PH];
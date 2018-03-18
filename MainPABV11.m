%========================================================================
% Function: Energy Hub Bidding in Integrated Energy System
% Author: Ricky (Rui Li) at Tsinghua & Harvard university
% E-mail: eeairicky@gmail.com eeairicky@seas.harvard.edu
% Version: 8.1 2017/12/03
% https://www.eia.gov/electricity/wholesale/
%========================================================================
clc; close all; clear all;
format short;
dbstop if error; 
warning off;

NT = 24; % [1,24]
U0 = 1.05;
SB = 10; % base value MW

%% ========== control option ============
Draw_EH = 1; 
Draw_P = 1; 
Draw_D = 1; 
SysPDN = 33;
SysDHN = 32;
Option_Price = 4; % TOU 1, Peak-Vally 2, 3 Random, 4 LMP
Option_Gas = 1; % cheap 1, expensive 2
Season = 4; % 1,2,3,4
BAU = 1;
GenCost_Plus = 0;
% GenCost_Plus = -1;
GenCost_Factor = 0;
switch Season
    case 1  % Spring
        SeasonP = 1; SeasonD = 2;
    case 2  % Summer
        SeasonP = 2; SeasonD = 1;
    case 3  % Fall
        SeasonP = 3; SeasonD = 3;
    case 4  % Winter
        SeasonP = 4; SeasonD = 3;
end

cp = 4.2; % KJ/(kg.K) 25¡æ
Ind_EH_PDN = 2;
Ind_EH_DHN = 31;

Cgrid1 = [0.08*ones(1,8) 0.11*ones(1,6) 0.15*ones(1,8) 0.08*ones(1,2)]; % $/(kW.h)TOU
Cgrid2 = [0.3/6*ones(1,7) 0.6/6*ones(1,14) 0.3/6*ones(1,3)]; % peak-valley
Cgrid3 = [0.033 0.027 0.020 0.017 0.017 0.029 0.033 0.054 ...
          0.215 0.572 0.572 0.572 0.033 0.027 0.020 0.017 ...
          0.017 0.029 0.033 0.054 0.215 0.572 0.572 0.572];
switch Option_Price
    case 1 
        Cgrid = 0.45*Cgrid1*1e3; % $/(MW.h)
    case 2
        Cgrid = 0.65*Cgrid2*1e3;
    case 3
        Cgrid = 0.15*Cgrid3*1e3;
    case 4
        load LMP_base.mat
        Cgrid = LMP_base;
    end
Cgrid = Cgrid*SB; % $/(p.u)
theta = Cgrid(1:NT); % $/(p.u)
if Option_Gas == 1
    gamma_gas = 26*ones(1,NT); % $/(MW.h) [18,26]  4*$/GJ = *$/(Mw.h) USA
else
    gamma_gas = 40*ones(1,NT); % China
end
gamma_gas = gamma_gas*SB; % p.u. 

Pgrid_max = 0.3*ones(1,NT); % p.u.
Qgrid_max = 0.3*ones(1,NT); % p.u.

%% ========== load data ============
eval('HBData') 
eval('SysPDN33'); % load 0.35 ~0.5 p.u.
eval('SysDHN32'); % load 0.2 p.u. 
eval('HeatLoadCurve');

%% ==========  Var & constraint ============
%%% Set the upper level variables as constant
Para_Price_P_in =  7758;
Para_Price_P_out = 201314;
Para_Price_H = 52121;
Para_Quan_P_in = 7474;
Para_Quan_P_out = 4747;
Para_Quan_H = 6886;

Pr_E_in = Para_Price_P_in*ones(1,NT);
Pr_E_out = Para_Price_P_out*ones(1,NT);
Pr_H = Para_Price_H*ones(1,NT);
p_hat_hub_in =  Para_Quan_P_in*ones(1,NT);
p_hat_hub_out = Para_Quan_P_out*ones(1,NT);
h_hat_hub = Para_Quan_H*ones(1,NT);

eval('VarHub'); 
% eval('VarHubBid');
eval('VarPDN'); 
eval('VarDHN'); 
eval('ConInterface'); % F_Inter_PH, F_Inter_UL
eval('ConPDN'); % F_PF_PDN
eval('ConDHN'); % F_PF_DHN
eval('ConHub'); % F_PF_Hub

F_PDN = [F_Inter_UL_P, F_PF_PDN, F_Inter_PH_P];
F_DHN = [F_Inter_UL_D, F_PF_DHN, F_Inter_PH_H];

%%  ============ Derive KKT system of PDN ===========
%%% Derive the Matrix Form
Obj_DOWN_PDN =  sum(Pr_E_out.*p_hub_out - Pr_E_in.*p_hub_in) + sum(Cgrid(1:NT).*Pgrid) + ...
                sum(sum(repmat((1+GenCost_Factor)*bg,1,NT).*Pg_GT,2)) + sum(sum(repmat(ag,1,NT).*Pg_GT.*Pg_GT,2));
[model_PDN,recoverymodel_PDN] = export(F_PDN, Obj_DOWN_PDN, sdpsettings('solver','cplex'))

%%% Define the upper variables
clear Pr_E_in Pr_E_out p_hat_hub_in p_hat_hub_out
Pr_E_in = sdpvar(1,NT,'full');
Pr_E_out = sdpvar(1,NT,'full');
p_hat_hub_in = sdpvar(1,NT,'full');
p_hat_hub_out = sdpvar(1,NT,'full');

%%% Find ind
Ind_Vara_P_out = getvariables(p_hub_out); % link var
Ind_Vara_P_in = getvariables(p_hub_in);
Ind_Coef_Price_P_out = find(model_PDN.f == Para_Price_P_out);  % link coef
Ind_Coef_Price_P_in = find(model_PDN.f == -Para_Price_P_in); % attention -Para_Price
Ind_Cons_Quan_P_out = find(model_PDN.bineq == Para_Quan_P_out); % link cons
Ind_Cons_Quan_P_in = find(model_PDN.bineq == Para_Quan_P_in);

%%% Update the Matrix form
x_kkt_PDN = sdpvar(length(recoverymodel_PDN.used_variables),1,'full');
miu_PDN =  sdpvar(size(model_PDN.Aineq,1),1,'full');
h_PDN = binvar(size(model_PDN.Aineq,1),1,'full');
lambda_PDN = sdpvar(size(model_PDN.Aeq,1),1,'full');
big_M = 1e5;

%%% Ind of other variables & constraints
Ind_Vara_Others = setdiff(1:size(x_kkt_PDN,1),[Ind_Vara_P_out, Ind_Vara_P_in]);
Ind_Cons_Others = setdiff(1:size(model_PDN.Aineq,1),[Ind_Cons_Quan_P_out, Ind_Cons_Quan_P_in]);

KKT_Cons_PDN = [];
% KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.Aineq*x_kkt_PDN <= model_PDN.bineq];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.Aineq(Ind_Cons_Quan_P_out,:)*x_kkt_PDN <= p_hat_hub_out'];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.Aineq(Ind_Cons_Quan_P_in,:)*x_kkt_PDN <= p_hat_hub_in'];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.Aineq(Ind_Cons_Others,:)*x_kkt_PDN <= model_PDN.bineq(Ind_Cons_Others)];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.Aeq*x_kkt_PDN == model_PDN.beq];

% KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.H*x_kkt_PDN + model_PDN.f == -model_PDN.Aineq'*miu_PDN + model_PDN.Aeq'*lambda_PDN];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.H(Ind_Vara_P_out,:)*x_kkt_PDN + Pr_E_out' == ...
    -model_PDN.Aineq(:,Ind_Vara_P_out)'*miu_PDN + model_PDN.Aeq(:,Ind_Vara_P_out)'*lambda_PDN];
% KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.H(Ind_Vara_P_in,:)*x_kkt_PDN + Pr_E_in' == ...
%     -model_PDN.Aineq(:,Ind_Vara_P_in)'*miu_PDN + model_PDN.Aeq(:,Ind_Vara_P_in)'*lambda_PDN];
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.H(Ind_Vara_P_in,:)*x_kkt_PDN - Pr_E_in' == ...
    -model_PDN.Aineq(:,Ind_Vara_P_in)'*miu_PDN + model_PDN.Aeq(:,Ind_Vara_P_in)'*lambda_PDN]; % attention - Pr_E_in
KKT_Cons_PDN = [KKT_Cons_PDN, model_PDN.H(Ind_Vara_Others,:)*x_kkt_PDN + model_PDN.f(Ind_Vara_Others,:) == ...
               -model_PDN.Aineq(:,Ind_Vara_Others)'*miu_PDN + model_PDN.Aeq(:,Ind_Vara_Others)'*lambda_PDN];

KKT_Cons_PDN = [KKT_Cons_PDN, 0 <= -model_PDN.Aineq(Ind_Cons_Quan_P_out,:)*x_kkt_PDN + p_hat_hub_out' <= big_M*h_PDN(Ind_Cons_Quan_P_out,:)];
KKT_Cons_PDN = [KKT_Cons_PDN, 0 <= -model_PDN.Aineq(Ind_Cons_Quan_P_in,:)*x_kkt_PDN + p_hat_hub_in' <= big_M*h_PDN(Ind_Cons_Quan_P_in,:)];
KKT_Cons_PDN = [KKT_Cons_PDN, 0 <= -model_PDN.Aineq(Ind_Cons_Others,:)*x_kkt_PDN + model_PDN.bineq(Ind_Cons_Others,:) <= big_M*h_PDN(Ind_Cons_Others,:)];
KKT_Cons_PDN = [KKT_Cons_PDN, 0 <= miu_PDN <= big_M*(1-h_PDN)];  

Link_PDN = [];
[Index,ia_out,ib] = intersect(recoverymodel_PDN.used_variables,Ind_Vara_P_out);
[Index,ia_in,ib] = intersect(recoverymodel_PDN.used_variables,Ind_Vara_P_in);
Link_PDN = [Link_PDN,x_kkt_PDN(ia_out) == p_hub_out'];
Link_PDN = [Link_PDN,x_kkt_PDN(ia_in) == p_hub_in'];

PDN_Final = [Link_PDN, KKT_Cons_PDN];

%%  ============ Derive KKT system of DHN ===========
Obj_DOWN_DHN = (1+GenCost_Factor)*alphaGB(DataDHN.IndGB(1),:)*sum(Hg_GB(DataDHN.IndGB(1),:).^2) + betaGB(DataDHN.IndGB(1),:)*sum(Hg_GB(DataDHN.IndGB(1),:))+...
      (1+GenCost_Factor)*alphaGB(DataDHN.IndGB(2),:)*sum(Hg_GB(DataDHN.IndGB(2),:).^2) + betaGB(DataDHN.IndGB(2),:)*sum(Hg_GB(DataDHN.IndGB(2),:)) + ...
      sum(Pr_H.*h_hub);
[model_DHN,recoverymodel_DHN] = export(F_DHN,Obj_DOWN_DHN,sdpsettings('solver','cplex'))

%% Define the upper variables
clear Pr_H h_hat_hub
Pr_H = sdpvar(1,NT,'full');
h_hat_hub = sdpvar(1,NT,'full');

%%% Find the ind 
Ind_Vara_H = getvariables(h_hub); % ink var
% !!!attention the overlap of variables when use twice export!!!
[Index,ia_out,ib] = intersect(recoverymodel_DHN.used_variables,Ind_Vara_H); 
Ind_Coef_Price_H = find(model_DHN.f == Para_Price_H);  % link coef
Ind_Cons_Quan_H = find(model_DHN.bineq == Para_Quan_H); % link cons

%%% Update the Matrix form
x_kkt_DHN = sdpvar(length(recoverymodel_DHN.used_variables),1,'full');
miu_DHN =  sdpvar(size(model_DHN.Aineq,1),1,'full');
h_DHN = binvar(size(model_DHN.Aineq,1),1,'full');
lambda_DHN = sdpvar(size(model_DHN.Aeq,1),1,'full');
big_M = 1e5;

Ind_Vara_Others_H = setdiff(1:size(x_kkt_DHN,1),[ia_out]); % attention !!!
Ind_Cons_Others_H = setdiff(1:size(model_DHN.Aineq,1),[Ind_Cons_Quan_H]);

KKT_Cons_DHN = [];
KKT_Cons_DHN = [KKT_Cons_DHN, model_DHN.Aineq(Ind_Cons_Quan_H,:)*x_kkt_DHN <= h_hat_hub'];
KKT_Cons_DHN = [KKT_Cons_DHN, model_DHN.Aineq(Ind_Cons_Others_H,:)*x_kkt_DHN <= model_DHN.bineq(Ind_Cons_Others_H)];
KKT_Cons_DHN = [KKT_Cons_DHN, model_DHN.Aeq*x_kkt_DHN == model_DHN.beq];

KKT_Cons_DHN = [KKT_Cons_DHN, model_DHN.H(ia_out,:)*x_kkt_DHN + Pr_H' == ...
    -model_DHN.Aineq(:,ia_out)'*miu_DHN + model_DHN.Aeq(:,ia_out)'*lambda_DHN]; 
KKT_Cons_DHN = [KKT_Cons_DHN, model_DHN.H(Ind_Vara_Others_H,:)*x_kkt_DHN + model_DHN.f(Ind_Vara_Others_H,:) == ...
               -model_DHN.Aineq(:,Ind_Vara_Others_H)'*miu_DHN + model_DHN.Aeq(:,Ind_Vara_Others_H)'*lambda_DHN];

KKT_Cons_DHN = [KKT_Cons_DHN, 0 <= -model_DHN.Aineq(Ind_Cons_Quan_H,:)*x_kkt_DHN + h_hat_hub' <= big_M*h_DHN(Ind_Cons_Quan_H,:)];
KKT_Cons_DHN = [KKT_Cons_DHN, 0 <= -model_DHN.Aineq(Ind_Cons_Others_H,:)*x_kkt_DHN + model_DHN.bineq(Ind_Cons_Others_H,:) <= big_M*h_DHN(Ind_Cons_Others_H,:)];
KKT_Cons_DHN = [KKT_Cons_DHN, 0 <= miu_DHN <= big_M*(1-h_DHN)];  

Link_DHN = [];
Link_DHN = [Link_DHN,x_kkt_DHN(ia_out) == h_hub'];
DHN_Final = [Link_DHN, KKT_Cons_DHN];

%% Cons. Hub Bid Seperate
F_PF_Hub_Bid = [];
F_PF_Hub_Bid = [F_PF_Hub_Bid, (p_hub_in_min <= p_hat_hub_in <= uhub_char*p_hub_in_max):'Hub_Pin_Bid_Bound']; 
F_PF_Hub_Bid = [F_PF_Hub_Bid, (p_hub_out_min <= p_hat_hub_out <= uhub_disc*p_hub_out_max):'Hub_Pout_Bid_Bound'];
% F_PF_Hub_Bid = [F_PF_Hub_Bid, (Pr_E_in_min <= Pr_E_in <= Pr_E_in_max):'Pr_E_in_limit1'];
% F_PF_Hub_Bid = [F_PF_Hub_Bid, (Pr_E_out_min <= Pr_E_out <= Pr_E_out_max):'Pr_E_out_limit1'];

F_PF_Hub_Bid = [F_PF_Hub_Bid, uhub_char + uhub_disc <= 1]; % debug
F_PF_Hub_Bid = [F_PF_Hub_Bid, (h_hub_min <= h_hat_hub <= h_hub_max):'Hub_H_Bid_Bound'];
F_PF_Hub_Bid = [F_PF_Hub_Bid, (Pr_H_min <= Pr_H <= Pr_H_max):'Pr_H_limit1'];
F_PF_Hub_Bid = [F_PF_Hub_Bid, (sum(Pr_H) <= NT*Pr_H_av):'Pr_H_limit2'];

F_PF_Hub = [F_PF_Hub, (Pr_E_in >= Cgrid):'Pr_E_in_limit1'];
F_PF_Hub = [F_PF_Hub, (Pr_E_out_min <= Pr_E_out <= 1.25*Pr_E_out_max):'Pr_E_out_limit1'];

% F_PF_Hub = [F_PF_Hub, (Pr_E_in_min <= Pr_E_in <= Pr_E_in_max):'Pr_E_in_limit1'];
% F_PF_Hub = [F_PF_Hub, (sum(Pr_E_in) <= NT*Pr_E_in_av):'Pr_E_in_limit2'];
% F_PF_Hub = [F_PF_Hub, (Cgrid <= Pr_E_out):'Pr_E_out_limit1']
% F_PF_Hub = [F_PF_Hub, Pr_E_out >= Pr_E_in]; % 11/10
% F_PF_Hub = [F_PF_Hub, (Sb*LMP_base <= Pr_E_out):'Pr_E_out_limit1']
% F_PF_Hub = [F_PF_Hub, (sum(Pr_E_out) <= NT*Pr_E_out_av):'Pr_E_out_limit2'];
eval('ConBEM'); % F_BEM_P, F_BEM_H

%% ===============  Final Problem   =================== 
Reve_PDN_disc_t = Pr_E_out_min*p_hub_out + delta_Pr_E_out*(BEM_Base*z_E_out);
Reve_PDN_char_t = Pr_E_in_min*p_hub_in + delta_Pr_E_in*(BEM_Base*z_E_in);
Reve_PDN = sum(Reve_PDN_disc_t) - sum(Reve_PDN_char_t);
Reve_DHN_t = Pr_H_min*h_hub + delta_Pr_H*(BEM_Base*z_H);  
Reve_DHN = sum(Reve_DHN_t);
Obj_UP = Reve_PDN + Reve_DHN - sum(gamma_gas.*p_gasin);

%%%%%%%%%%%% Debug options %%%%%%%%%%%%
% Obj_UP = Revenue_PDN;
% Obj_UP = Revenue_DHN;
% Obj_UP = Revenue_DHN + Revenue_PDN;

% Cons_Final = [F_PF_Hub_Bid, PDN_Final, F_BEM_P, F_PDN];% 
% Cons_Final = [F_PF_Hub_Bid, DHN_Final, F_BEM_H, F_DHN];%

Cons_Final = [F_PF_Hub_Bid, F_PF_Hub, PDN_Final, F_BEM_P, F_PDN, DHN_Final, F_BEM_H, F_DHN];
   
ops = sdpsettings('solver','cplex');
ops.cplex.epgap = 5*1e-3;
ops.cplex.epagap = 5*1e-3;
% ops.cplex.epgap = 1e-3;
% ops.cplex.epagap = 1e-3;
tic
sol = optimize(Cons_Final,-Obj_UP,ops) % attention -Obj max
toc

if sol.problem == 0
    disp('successed!')
    switch Season
        case 1
            save Result_Season1.mat 
        case 2
            save Result_Season2.mat
        case 3
            save Result_Season3.mat
        case 4
            if BAU == 1
              save Result_Season4_BAU.mat
            elseif Option_Gas == 2
              save Result_Season4_Gas2.mat
            elseif Option_Price == 1
              save Result_Season4_BAU_TOU.mat 
            elseif Option_Price == 2
              save Result_Season4_BAU_PV.mat  
            elseif Option_Price == 3
              save Result_Season4_BAU_Random.mat
            elseif GenCost_Plus == 1
                save Result_GenCostPlus.mat
            elseif GenCost_Plus == -1
                 save Result_GenCostPlus.mat
            end
    end
        
    Profit = value(Obj_UP)
    
    % ==============  Cost Hub ====================
    disp('Revenue of Energy Hub')
    R_Reve_PDN_disc = value(sum(Reve_PDN_disc_t))
    R_Reve_PDN_char = value(sum(Reve_PDN_char_t))
    R_Reve_PDN = R_Reve_PDN_disc - R_Reve_PDN_char;
    R_Reve_DHN = value(sum(Reve_DHN_t));
    R_Reve_Gas = value(sum(gamma_gas.*p_gasin))
    Profit = R_Reve_PDN + R_Reve_DHN - R_Reve_Gas

    %  ============= Cost PDN ====================
    disp('Operation cost of PDN')
    P_Cost_GT = value(sum(repmat(ag,1,NT).*((Pg_GT).^2) + repmat(bg,1,NT).*(Pg_GT),2));
    P_Cost_Grid = value(Cgrid(1:NT)*Pgrid');
    P_Cost_Hub = value(sum(Pr_E_out.*p_hub_out) - sum(Pr_E_in.*p_hub_in));
    P_Cost = [P_Cost_Grid, P_Cost_GT(IndGT(1)), P_Cost_GT(IndGT(2)),P_Cost_Hub]

    figure
    subplot(1,2,1)
    pie(P_Cost)
    legend('Grid','GT1','GT2','EH')
    title('Daily operation cost of PDN ($)')
    
    % ============== Cost DHN ====================
    disp('Operation cost of DHN')
    H_Cost_GB1 = value(alphaGB(DataDHN.IndGB(1),:)*sum(Hg_GB(DataDHN.IndGB(1),:).^2) + betaGB(DataDHN.IndGB(1),:)*sum(Hg_GB(DataDHN.IndGB(1),:)));
    H_Cost_GB2 = value(alphaGB(DataDHN.IndGB(2),:)*sum(Hg_GB(DataDHN.IndGB(2),:).^2) + betaGB(DataDHN.IndGB(2),:)*sum(Hg_GB(DataDHN.IndGB(2),:)));
    H_Cost_Hub = value(sum(Pr_H.*h_hub));
    H_Cost = [H_Cost_GB1, H_Cost_GB2, H_Cost_Hub]
    
    subplot(1,2,2)
    pie(H_Cost)
    legend('GB1','GB2','EH')
    title('Daily operation cost of DHN ($)')
   
    if Draw_EH
        eval('DrawPriceEH')
        eval('DrawEH')
    end
    if Draw_P % PDN draw
        eval('DrawPDNFlow');
%         eval('DrawLMEP');
    end
%     if Draw_D % DHN draw
%         eval('CalHeatloss');
%         eval('DrawCFVT');
% %         eval('DrawLMHP');
%         eval('DrawLoss');
%     end
else
    display('Hmm, the startup of SmarterRLC would fail!');
    sol.info
    yalmiperror(sol.problem)
end

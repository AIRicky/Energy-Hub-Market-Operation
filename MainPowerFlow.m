%========================================================================
% Function: Power Distribution Network Optimal Flow
% Author: Ricky (Rui Li) at Tsinghua & Harvard university
% E-mail: eeairicky@gmail.com liruibdwdm@yeah.net
% Version: 2.0  2017/09/29
% Features:
%       (1) PDN topo. can be flexible selected.
%       (2) Single & multipe periods are supported.
%       (3) Support different load shape --> multi-scenaries
%       (4) LMEP is given. --> operation optimization
% History:
%        2019/09/29 Optimize code
% Next:
%     (1) Add the option of linearize or SOCP?
%     (2) Add the PV output?
%     (3) Test the IEEE 14 bus system?
%     (4) Add the option of OLTC?
%========================================================================
clc; close all; clear all;
format short;
dbstop if error; % debug
% ========== control option ============
NT = 1; % 1,3,6,12,24
SysPDN = 33;
SeasonP = 0;  % 0,1,2,3,4
DrawOption = 0; %  no draw
GridPriceOption = 1; % TOU 1, Peak-Vally 2
% ========== load data ============
switch SysPDN
    case 33
        eval('PDN33');
    case 14
        pause(1e-10)
end
% ==========  Var & constraint ============
eval('VarConPDN');
% ========== Obj ============
% C_grid = 1500; % 0.15$/(kW.h) -> 1500$/(p.u)
Cgrid1 = [0.08*ones(1,8) 0.11*ones(1,6) 0.15*ones(1,8) 0.08*ones(1,2)];
Cgrid2 = [0.3/6*ones(1,7) 0.6/6*ones(1,14) 0.3/6*ones(1,3)]; % peak, off-peak price 
if GridPriceOption == 1
    Cgrid = Cgrid1;
else
    Cgrid = Cgrid2;
end
Cgrid = Cgrid * 1e4; % p.u.
CostGrid = Cgrid(1:NT)*Pgrid'; % cost of purchasing elec. from PTO
CostGen = sum(sum(repmat(ag,1,NT).*((Sb*Pg_GT).^2) + repmat(bg,1,NT).*(Sb*Pg_GT)));
Obj = CostGen + CostGrid;
% ==========Solve============
tic
sol = optimize(F,Obj,sdpsettings('solver','cplex,mosek'))
toc
% ==========Analyze============
if sol.problem == 0
    disp('successed!')
    save RLPDNdata.mat
    Utility = value(CostGrid)
    CostGT = value(CostGen)
    Cost = value(Obj)
    WindCur = sum(Wg_u(IndGenW,:) - value(Wg(IndGenW,:)))
    Cur = WindCur;
    if DrawOption
        eval('DrawPDNFlow');
        eval('DrawLMEP');
    end
else
    display('Hmm, something went wrong! Stanford!!!');
    sol.info
    yalmiperror(sol.problem)
end


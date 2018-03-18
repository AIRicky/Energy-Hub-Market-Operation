%========================================================================
% Function: Optimal heat power flow
% Author: Ricky (Rui Li) at Tsinghua & Harvard university
% E-mail: eeairicky@gmail.com liruibdwdm@yeah.net
% Version: 2.1  2017/09/29
% Features:
%       (1) DHN topo. can be flexible selected
%       (2) Single & multipe periods are supported
%       (3) Support different load shape --> multi-scenaries
%       (4) 3D Heat power & loss --> capacity expansion 
%       (5) 3D Temp. distrib. --> reduce loss
%       (6) LMHP is given. --> operation optimization    
% History: 
%       2017/05/22  Heat Flow and LMHP, successed
%       2017/05/22  DHN 32 Transported heat power and heat loss
%       2017/05/22  Three kind of heat load curve
%       2017/09/28  Optimize and pack the code
%       2017/09/29  Add the total thermal balance equation ??
% Debug:
%       2017/09/29 (1) Can I add the feasibility check process?
%                  (2) SysDHN 8 single source is not possible.
%                  (3) SysDHN 8 can not be shaped with other heat shape.
%=======================================================================
clc; close all; clear all;
format short;
dbstop if error; % debug
% ===========control area ===========
NT = 24; % 1,6,12,24
cp = 4.2; % KJ/(kg.K) 25¡æ
Drawoption = 1; % drawoff-0, drawon-1
Season = 0; % normal-0, summer-1, spring-2, fall-winter-3 
Scheme = 0; % CF-VT-0, VF-VT-1
SysDHN = 8; %    
switch SysDHN
    case 32
        eval('SysDHN32');
    case 8
        eval('SysDHN8');
end
eval('HeatLoadCurve');
eval('HeatVarCon');
Obj = sum(sum(repmat(coeff1,1,NT).*((Hg_HP(Nd_Hs,:)/1e3).^2)+...
    repmat(coeff2,1,NT).*(Hg_HP(Nd_Hs,:)/1e3)));
tic
sol = optimize(F,Obj,sdpsettings('solver','mosek,cplex'))
toc
% [kktsystem, details] = kkt(F,Obj)
% checkset(F)
if sol.problem == 0
    disp('successed!')
    ObjV = value(Obj)
    eval('CalHeatloss');
    if Drawoption
        eval('DrawCFVT');
        eval('DrawLMHP');
        eval('DrawLoss');
    end
    save RLData.mat
else
    display('Hmm, the startup of SmarterRLC would fail!');
    sol.info
    yalmiperror(sol.problem)
end

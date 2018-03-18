clc; clear all

% 处理下层
sdpvar y1 y2 y3 y4 % lower-level variable
x1 = 10;  x2 = 10; % 令上层变量 x1, x2 为常数

OI = x1^2 + x1 + x2^2 + 2*x2 + y1^2 + y1 + y2 + 2*y3; % low-obj
CI = [ y1 + y2 == 8; % low-constraints
       y2 + y4 == 8; 
       y3 + y4 == 10;
     -y1 + y2 + y3 <= 10,
      2*x1 - y1 + 2*y2 - 0.5*y3 <= 10,
      2*x2 + 2*y1 - y2 - 0.5*y3 <= 9.7,
                     [y1 y2 y3] >= 0];

% Export matrix
[model_Matrix,recoverymodel_Matrix] = export(CI, OI, sdpsettings('solver','cplex'))
x_kkt = sdpvar(length(recoverymodel_Matrix.used_variables),1,'full');
miu = sdpvar(size(model_Matrix.Aineq,1),1,'full');
h = binvar(size(model_Matrix.Aineq,1),1,'full');
lambda = sdpvar(size(model_Matrix.Aeq,1),1,'full');
big_M = 1e5;

sdpvar x1 x2
% model_Matrix.bineq(2,1) = 10 -2*x1;
% model_Matrix.bineq(3,1) = 9.7-2*x2;
% Interf = [];
% Interf = [Interf, model_Matrix.bineq(2,1) == 10 -2*x1];
% Interf = [Interf, model_Matrix.bineq(3,1) == 9.7-2*x2];

% sdpvar 
% KKT system
KKT_Cons = [];
% KKT_Cons = [KKT_Cons, model_Matrix.Aineq*x_kkt <= model_Matrix.bineq];
KKT_Cons = [KKT_Cons, model_Matrix.Aineq([1,4,5,6],:)*x_kkt <= model_Matrix.bineq([1,4,5,6])];
KKT_Cons = [KKT_Cons, model_Matrix.Aineq([2,3],:)*x_kkt <= [10-2*x1; 9.7-2*x2]];
KKT_Cons = [KKT_Cons, model_Matrix.Aeq*x_kkt == model_Matrix.beq];
KKT_Cons = [KKT_Cons, model_Matrix.H*x_kkt + model_Matrix.f == -model_Matrix.Aineq'*miu + model_Matrix.Aeq'*lambda];
KKT_Cons = [KKT_Cons, 0 <= -model_Matrix.Aineq([1,4,5,6],:)*x_kkt + model_Matrix.bineq([1,4,5,6]) <= big_M*h([1,4,5,6])];
KKT_Cons = [KKT_Cons, 0 <= -model_Matrix.Aineq([2,3],:)*x_kkt + [10-2*x1; 9.7-2*x2] <= big_M*h([2,3])];
KKT_Cons = [KKT_Cons, 0 <= miu <= big_M*(1-h)];  

% 重新将x1 x2 定义为变量
% sdpvar x1 x2 
OO = -8*x1 - 4*x2 + 4*y1 - 40*y2 + 4*y3; % up-obj
CO = [[x1 x2] >=0]; % up-cons
CI = [ y1 + y2 == 8; % low-constraints
       y4 + y2 == 8;
       y3 + y4 == 10;
     -y1 + y2 + y3 <= 10,
      2*x1 - y1 + 2*y2 - 0.5*y3 <= 10,
      2*x2 + 2*y1 - y2 - 0.5*y3 <= 9.7,
                     [y1 y2 y3] >= 0];  
% % 建立下层变量与矩阵形式间的关系
Link = [];
y_index_in = find(recoverymodel_Matrix.used_variables == getvariables([y1]));
Link = [Link, x_kkt(y_index_in) == y1];
y_index_in = find(recoverymodel_Matrix.used_variables == getvariables([y2]));
Link = [Link, x_kkt(y_index_in) == y2];
y_index_in = find(recoverymodel_Matrix.used_variables == getvariables([y3]));
Link = [Link, x_kkt(y_index_in) == y3];

% 
Cons_final = [CO,KKT_Cons,Link, CI];
% 

% 
tic
sol = optimize(Cons_final,OO,sdpsettings('solver','cplex'));
toc

R_x  = value([x1 x2 y1 y2 y3 y4])
R_OO = value(OO)


%% 最优解
sdpvar y1 y2 y3 y4
sdpvar x1 x2
OI = x1^2 + x1 + x2^2 + 2*x2 + y1^2 + y1 + y2 + 2*y3; % low-obj
CI = [ y1 + y2 == 8; % low-constraints
       y2 + y4 == 8;
       y3 + y4 == 10;
     -y1 + y2 + y3 <= 10,
      2*x1 - y1 + 2*y2 - 0.5*y3 <= 10,
      2*x2 + 2*y1 - y2 - 0.5*y3 <= 9.7,
                     [y1 y2 y3] >= 0];
OO = -8*x1 - 4*x2 + 4*y1 - 40*y2 + 4*y3; % up-obj
CO = [[x1 x2] >=0]; % up-cons    
solvebilevel(CO,OO,CI,OI,[y1 y2 y3 y4])
Obj = value(OO)
variable = value([x1 x2 y1 y2 y3 y4])
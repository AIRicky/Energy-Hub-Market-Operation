[model,recoverymodel] = export(F,Obj,sdpsettings('solver','cplex'))
x_kkt = sdpvar(length(recoverymodel.used_variables),1,'full');
miu =  sdpvar(size(model.Aineq,1),1,'full');
h = binvar(size(model.Aineq,1),1,'full');
lambda = sdpvar(size(model.Aeq,1),1,'full');
big_M = 1e5;

KKT_Cons = [];
KKT_Cons = [KKT_Cons, model.Aineq*x_kkt <= model.bineq];
KKT_Cons = [KKT_Cons, model.Aeq*x_kkt == model.beq];
KKT_Cons = [KKT_Cons, model.H*x_kkt + model.f == -model.Aineq'*miu + model.Aeq'*lambda];

KKT_Cons = [KKT_Cons, 0 <= -model.Aineq*x_kkt + model.bineq <= big_M*h];
KKT_Cons = [KKT_Cons, 0 <= miu <= big_M*(1-h)];
% 
optimize(KKT_Cons,[],sdpsettings('solver','cplex'));
GB1 = reshape(x_kkt(getvariables(Hg_GB(DataDHN.IndGB(1),:))),1,NT);
GB2 = reshape(x_kkt(getvariables(Hg_GB(DataDHN.IndGB(2),:))),1,NT);
GB3 = reshape(x_kkt(getvariables(Hg_GB(DataDHN.IndGB(3),:))),1,NT);
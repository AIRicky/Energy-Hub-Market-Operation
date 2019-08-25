  
figure  % Power source output 
subplot(2,1,1)
data1 = Sb*sum(Pd);
data2 = Sb*value(Pg_EH_in(DataPDN.IndEH,:));
data = [data1',data2']; % ,data5'
bar(data,0.75,'stack')
hh = legend('$p^{d}$','$p^{in}$') %
hh.Orientation = 'horizontal';
xlabel('time (h)')
ylabel('demand (MW)')
set(legend,'Interpreter','latex')


subplot(2,1,2)
%     R_Pg_GT = reshape(x_kkt_PDN(getvariables(Pg_GT)-recoverymodel_PDN.used_variables(1) + 1),N_Bus,NT);
%     R_Pgrid = reshape(x_kkt_PDN(getvariables(Pgrid)-recoverymodel_PDN.used_variables(1) + 1),1,NT);
data1 = Sb*value(Pgrid);
data2 = Sb*value(Pg_GT(IndGT(1),:));
data3 = Sb*value(Pg_GT(IndGT(2),:));
data4 = Sb*value(Pg_EH_out(DataPDN.IndEH,:));
%     data5 = Sb*value(-Pg_EH_in(DataPDN.IndEH,:));
data = [data1',data2',data3',data4']; % ,data5'
bar(data,0.75,'stack')
hh = legend('$p^{grid}$','$p_1^{g}$','$p_2^{g}$','$p^{out}$') %,'$p^{hub,in}$'
hh.Orientation = 'horizontal';
xlabel('time (h)')
ylabel('generation (MW)')
set(legend,'Interpreter','latex')
    
%     subplot(2,1,2)
%     R_Qg_GT = reshape(x_kkt_PDN(getvariables(Qg_GT)-recoverymodel_PDN.used_variables(1) + 1),N_Bus,NT);
%     R_Qgrid = reshape(x_kkt_PDN(getvariables(Qgrid)-recoverymodel_PDN.used_variables(1) + 1),1,NT);
%     R_Qg_SVG = reshape(x_kkt_PDN(getvariables(Qg_SVG)-recoverymodel_PDN.used_variables(1) + 1),N_Bus,NT);
%     data0 = Sb*value(R_Qgrid);
%     data1 = Sb*value(R_Qg_GT(IndGT(1),:));
%     data2 = Sb*value(R_Qg_GT(IndGT(2),:));
%     data3 = Sb*value(Qg_SVG(IndSVG(1),:));
%     data4 = Sb*value(Qg_SVG(IndSVG(2),:));
%     data = [data0', data1', data2', data3', data4'];
%     bar(data,0.72,'stack')
%     legend('$q^{grid}$','$q_1^g$','$q_2^g$','$q_1^c$','$q_2^c$')
%     xlabel('Time (h)')
%     ylabel('Reactive power (MVar)')
%     set(legend,'Interpreter','latex')

%     if NT >= 2
%         figure
% %         R_P = reshape(x_kkt_PDN(getvariables(P)-recoverymodel_PDN.used_variables(1) + 1),N_line,NT);
% %         R_Q = reshape(x_kkt_PDN(getvariables(Q)-recoverymodel_PDN.used_variables(1) + 1),N_line,NT);
%         subplot(2,2,1)
%         surf(Sb*value(P))
%         shading interp
%         colorbar
%         xlabel('Time (h)')
%         ylabel('Line no.')
%         zlabel('Active power flow (MW)')
%         subplot(2,2,2)
%         surf(Sb*value(Q))
%         shading interp
%         colorbar
%         xlabel('Time (h)')
%         ylabel('Line no.')
%         zlabel('Reactive power flow (MVar')
%         subplot(2,2,3)
%         pcolor(Sb*value(P))
%         xlabel('Time (h)')
%         ylabel('Line no.')
%         title('Active power P(MW).')
%         colorbar
%         subplot(2,2,4)
%         pcolor(Sb*value(Q))
%         xlabel('Time (h)')
%         ylabel('Line no.')
%         title('Reactive power P(MVar).')
%         colorbar
%         
%         figure
%         R_U2 = reshape(x_kkt_PDN(getvariables(U2)-recoverymodel_PDN.used_variables(1) + 1),N_Bus,NT);
%         subplot(2,1,1)
%         surf(value(R_U2))
%         shading interp
%         colorbar
%         xlabel('Time (h)')
%         ylabel('Nodal no.')
%         zlabel('Voltage (p.u.)')
%         subplot(2,1,2)
%         pcolor(value(R_U2))
%         xlabel('Time (h)')
%         ylabel('Nodal no.')
%         title('Voltage (p.u.).')
%         colorbar
%     else
%         pause(1e-10)
%     end

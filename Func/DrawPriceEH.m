    warning off
    figure
    plot(1:NT,LMP_base(1:NT),'-g^')
    hold on
    plot(1:NT,0.45*1e3*Cgrid1(1:NT),'-bs')
    plot(1:NT,0.65*1e3*Cgrid2(1:NT),'-r*')
    plot(1:NT,0.15*1e3*Cgrid3(1:NT),'-co')
    xlabel('time (h)')
    ylabel('price ($/(MWh))')
    hh = legend('LMP','TOU', 'P-V', 'Exe');%
    hh.Orientation = 'horizontal';
    
    figure
    plot(1:NT,Cgrid(1:NT)/Sb,'-ks') % 
    hold on 
    plot(1:NT,gamma_gas(1:NT)/Sb,'-.rp')  % 
%     plot(1:NT,value(Pr_E_out)/Sb,'-c*')
%     plot(1:NT,value(Pr_E_in)/Sb,'-bo')
%     plot(1:NT,value(Pr_H)/Sb,'-g^')
%     h0 = legend('$b_0$','$\gamma$','$\xi^b$','$\chi^b$','$\zeta^b$');
    h0 = legend('$b_0$','$\gamma$');
    h0.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('price ($/(MWh))')
    set(legend,'Interpreter','latex')

    figure
    subplot(2,2,1)
    data1 = Sb*sum(Pd);
    data2 = Sb*value(Pg_EH_in(DataPDN.IndEH,:));
    data = [data1',data2']; 
    bar(data,0.75,'stack')
    hh = legend('$p^{d}$','$p^{db}$') %
    hh.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('demand (MW)')
    set(legend,'Interpreter','latex')

    subplot(2,2,2)
    data1 = Sb*value(Pgrid);
    data2 = Sb*value(Pg_GT(IndGT(1),:));
    data3 = Sb*value(Pg_GT(IndGT(2),:));
    data4 = Sb*value(Pg_EH_out(DataPDN.IndEH,:));
    data = [data1',data2',data3',data4'];
    bar(data,0.75,'stack')
    h1 = legend('$p_0^{g}$','$p_1^{g}$','$p_2^{g}$','$p^{gb}$'); 
    h1.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('generation (MW)')
    set(legend,'Interpreter','latex')
    subplot(2,2,3)
    index_in = find(value(p_hub_in) > 0);
    index_out = find(value(p_hub_out) >0);
    if ~isempty(index_in)
       pause(1e-3); 
    end
    if ~isempty(index_out)
       pause(1e-3); 
    end
    plot(1:NT,value(Pr_E_out)/Sb,'-b*') % uhub_disc.
    hold on
    plot(1:NT,value(Pr_E_in)/Sb,'-gs') % uhub_char
    hh = legend('$\xi^b$','$\chi^b$')
    hh.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('price ($/(MWh))')
    set(legend,'Interpreter','latex')
    subplot(2,2,4)
    plot(1:NT,Sb*value(p_hat_hub_in),'-bs') 
    hold on 
    plot(1:NT,Sb*value(p_hat_hub_out),'-go') 
    plot(1:NT,Sb*value(p_hub_in),'-c*') 
    plot(1:NT,Sb*value(p_hub_out),'-rp') 
    h2 = legend('$\hat p^{db}$','$\hat p^{gb}$','$p^{db}$','$p^{gb}$');
    h2.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('quantity (MW))')
    set(legend,'Interpreter','latex')
    
    figure
%     subplot(3,1,1)
%     data1 = Sb*value(Hg_GB(DataDHN.IndGB(1),:));   % heat source
%     data2 = Sb*value(Hg_GB(DataDHN.IndGB(2),:));   % heat source
%     data3 = Sb*value(Hg_EH(DataDHN.IndEH,:));
%     data = [data1', data2',data3'];
%     bar(data,0.75,'stack')
%     h3 = legend('$h_1^g$','$h_2^{g}$','$h^{b}$');
%     h3.Orientation = 'horizontal';
%     xlabel('time (h)')
%     ylabel('generation (MW)') 
%     set(legend,'Interpreter','latex')
    
    
    subplot(2,1,1)
    plot(1:NT,value(Pr_H)/Sb,'-bo') 
    legend('$\zeta^b$')
    xlabel('time (h)')
    ylabel('price ($/(MWh))')
    set(legend,'Interpreter','latex')
       
    subplot(2,1,2)
    plot(1:NT,Sb*value(h_hat_hub),'-bo') 
    hold on 
    plot(1:NT,Sb*value(h_hub),'-rs') 
    h4 = legend('$\hat h^{out}$','$h^{out}$');
    h4.Orientation = 'horizontal';
    xlabel('time (h)')
    ylabel('quantity (MW))')
    set(legend,'Interpreter','latex')
 
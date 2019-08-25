%     figure % generation & demand
%     subplot(2,1,1)
%     plot(1:NT,Sb*sum(H_Hd),'-bo')     % heat load
%     legend('h^d')
%     xlabel('Time (h)')
%     ylabel('Heat Demand (MW)')
%     switch SysDHN
%         case 32
%             subplot(2,1,2)
%             data1 = Sb*value(Hg_GB(DataDHN.IndGB(1),:));   % heat source
%             data2 = Sb*value(Hg_GB(DataDHN.IndGB(2),:));   % heat source
%             data3 = Sb*value(Hg_EH(DataDHN.IndEH,:));
%             data = [data1', data2',data3'];
%             bar(data,0.75,'stack')
%             legend('h_1^g','h_2^{g}','h^{hub}')
%             xlabel('Time (h)')
%             ylabel('Heat Generation (MW)') 
%         case 8
%             subplot(2,1,2)
%             data1 = Sb*value(Hg_HP(1,:))/1e3;   % heat source
%             data2 = Sb*value(Hg_HP(7,:))/1e3;
%             data = [data1', data2'];
%             bar(data,0.75,'stack')
%             legend('h_1^g','h_7^g')
%             xlabel('Time (h)')
%             ylabel('Heat Generation (MW)')
%     end

    
%     figure  % temp. of coupling node source
%     switch SysDHN
%         case 32
%             plot(1:NT,Taob*value(tao_NS(1,:)),'-bo')
%             hold on
%             plot(1:NT,Taob*value(tao_NR(1,:)),'-bs')
%             plot(1:NT,Taob*value(tao_NS(31,:)),'-ro')
%             plot(1:NT,Taob*value(tao_NR(31,:)),'-rs')
%             plot(1:NT,Taob*value(tao_NS(32,:)),'-go')
%             plot(1:NT,Taob*value(tao_NR(32,:)),'-gs')
%             xlabel('Time (h)')
%             ylabel(['Temperature (^{\circ}C)'])
%             legend('\tau_{GB1}^{S}','\tau_{GB1}^{R}','\tau_{EH}^{S}',...
%                 '\tau_{EH}^{R}','\tau_{GB2}^{S}','\tau_{GB2}^{R}')    
%             title('Temperature at heat source node')
%         case 8
%             plot(1:NT,Taob*value(tao_NS(1,:)),'-bo')
%             hold on
%             plot(1:NT,Taob*value(tao_NR(1,:)),'-bs')
%             plot(1:NT,Taob*value(tao_NS(7,:)),'-go')
%             plot(1:NT,Taob*value(tao_NR(7,:)),'-gs')
%             xlabel('Time (h)')
%             ylabel(['Temperature (^{\circ}C)'])
%             legend('\tau_1^{S}','\tau_1^{R}','\tau_{7}^{S}','\tau_{7}^{R}')     
%             title('Temperature at heat source node')
%     end
    
%     figure % temp. distribution
%     tth1 = 6; % eve. peak
%     tth2 = 5;  % mor. peak
%     Drawerr = 0;
%     if max([tth1,tth2]) >= NT
%         Drawerr = 1;
%         disp('The time slot NT is smaller than tth1 & tth2')
%         tth1 = round(rand(1,1)*NT); % random time
%         tth2 = round(rand(1,1)*NT); 
%         if  tth1&tth2 ==0
%             tth1 = 1;
%             tth2 = NT;
%         end
%     end
%     plot(1:N_Pipe,Taob*value(tao_PS_F(:,tth2)),'-go')
%     hold on
%     plot(1:N_Pipe,Taob*value(tao_PS_T(:,tth2)),'-cs')
%     plot(1:N_Pipe,Taob*value(tao_PS_T(:,tth1)),'-bs')
%     plot(1:N_Pipe,Taob*value(tao_PS_F(:,tth1)),'-ro')
%     plot(1:N_Pipe,Taob*value(tao_PR_F(:,tth1)),'-.ro')
%     plot(1:N_Pipe,Taob*value(tao_PR_T(:,tth1)),'-.bs')
%     plot(1:N_Pipe,Taob*value(tao_PR_F(:,tth2)),'-.go')
%     plot(1:N_Pipe,Taob*value(tao_PR_T(:,tth2)),'-.cs')
%     xlabel('Pipe No.')
%     ylabel('Temperature (^{\circ}C)')
%     if ~Drawerr
%     legend('\tau^{S,in}_{20}','\tau^{S,out}_{20}','\tau^{S,in}_{5}',...
%         '\tau^{S,out}_{5}','\tau^{R,in}_{20}','\tau^{R,out}_{20}',...
%         '\tau^{R,in}_{5}','\tau^{R,out}_{5}')    
%     end
%     figure % temp. distrib. at key time & node
%     nn1 = 5; %  node
%     subplot(2,1,1)
%     plot(1:N_Node,Taob*value(tao_NS(:,tth1)),'-ro')
%     hold on
%     plot(1:N_Node,Taob*value(tao_NR(:,tth1)),'-go')
%     plot(1:N_Node,Taob*value(tao_NS(:,tth2)),'-bs')
%     plot(1:N_Node,Taob*value(tao_NR(:,tth2)),'-ks')   
%     xlabel('Node No.')
%     ylabel('Temperature (^{\circ}C)')
%     legend('\tau^{S}_{20}','\tau^{R}_{20}','\tau^{S}_{5}','\tau^{R}_{5}')
%     subplot(2,1,2)
%     plot(1:NT,Taob*value(tao_NS(nn1,:)),'-ro')
%     hold on
%     plot(1:NT,Taob*value(tao_NR(nn1,:)),'-bs')
%     xlabel('Time (h)')
%     ylabel(['Temperature of node 5 (^{\circ}C) '])
%     legend('\tau_{NS}','\tau_{NR}')

    figure % temp distribution 3D
%     R_tao_NS = reshape(x_kkt_DHN(getvariables(tao_NS)-recoverymodel_DHN.used_variables(1) + 1),N_Node,NT);
%     R_tao_NR = reshape(x_kkt_DHN(getvariables(tao_NR)-recoverymodel_DHN.used_variables(1) + 1),N_Node,NT);
    subplot(2,1,1)
    surf(Taob*value(tao_NS))
    shading interp
    colorbar
    xlabel('Time (h)')
    ylabel('Pipe no.')
    zlabel('Supply node temp.')
    subplot(2,1,2)
    surf(Taob*value(tao_NR))
    shading interp
    colorbar
    xlabel('Time (h)')
    ylabel('Pipe no.')
    zlabel('Return node temp.')

    figure % temp distribution 3D
    subplot(2,1,1)
    pcolor(Taob*value(tao_NS))
    xlabel('Time (h)')
    ylabel('Pipe no.')
    title('Supply node temp.')
    colorbar
    subplot(2,1,2)
   pcolor(Taob*value(tao_NR))
    xlabel('Time (h)')
    ylabel('Pipe no.')
    title('Return node temp.')
    colorbar
%    
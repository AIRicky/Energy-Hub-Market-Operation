% dataSour = abs(dual(F('Source')));
% dataLoad = abs(dual(F('Load')));
% figure
% switch SysDHN
%     case 32 % DHN 32
%         plot(1:NT,dataSour(1,:),'-*');
%         hold on
%         plot(1:NT,dataSour(31,:),'-r+');
%         plot(1:NT,dataSour(32,:),'-gs');
%         plot(1:NT,dataLoad(3,:),'-kp');
%         plot(1:NT,dataLoad(17,:),'-yo');
%         xlabel('Time (h)')
%         ylabel('LMHP ($/kW.h)')
%         legend('H1-HP','H2-HP','H3-HP','N3-Load','N17-Load')
%     case 8 % DHN 8
%         plot(1:NT,dataSour(1,:),'-*');
%         hold on
%         plot(1:NT,dataSour(7,:),'-r+');
%         plot(1:NT,dataSour(5,:),'-gs');
%         plot(1:NT,dataLoad(6,:),'-kp');
%         plot(1:NT,dataLoad(8,:),'-yo');
%         xlabel('Time (h)')
%         ylabel('LMHP ($/kW.h)')
%         legend('H1-HP','H7-HP','N5-load','N6-Load','N8-Load')
%         
% end
        


switch SysPDN
    case 33
%         figure
% %         subplot(2,2,1)
%         plot(1:NT,Cgrid(1:NT)/Sb,'-o');
%         hold on
%         plot(1:NT,value(lambda_E(IndGT(1),:))/Sb,'-gs');
%         plot(1:NT,value(lambda_E(IndGT(2),:))/Sb,'-y*');
%         xlabel('Time (h)');
%         ylabel('LMEP ($/MWh)');
%         legend('B1-Grid','B7-GT1','B13-GT2')
%         
%         PricePDN = dual(F('DualPDN'));
%         subplot(2,2,2)
%         plot(1:NT,Cgrid(1:NT),'-bo');
%         hold on
%         plot(1:NT,abs(PricePDN(1,:)),'r:');
%         legend('C_{grid}','C_{grid}-dual')
%         xlabel('Time (h)')
%         ylabel('Price ($/p.u.)')
%         
%         subplot(2,2,3)
%         plot(1:NT,abs(value(lambda_E(IndGT(1),:))),'-bs');
%         hold on
%         plot(1:NT,abs(value(lambda_E(IndGT(2),:))),'-b*');
%         plot(1:NT,abs(PricePDN(IndGT(1),:)),':rs');
%         plot(1:NT,abs(PricePDN(IndGT(2),:)),':r*');
%         xlabel('Time (h)')
%         ylabel('Price ($/p.u.)')
%         legend('\lambda_{GT1}^E','\lambda_{GT2}^E','\lambda_{GT1}^E-dual','\lambda_{GT2}^E-dual')
%         
%         subplot(2,2,4)
%         plot(1:NT,abs(value(lambda_E(IndGenW,:))),'-bs');
%         hold on
%         plot(1:NT,abs(value(lambda_E(19,:))),'-b+');
%         plot(1:NT,abs(PricePDN(IndGenW,:)),':rs');
%         plot(1:NT,abs(PricePDN(19,:)),':r+');
%         xlabel('Time (h)')
%         ylabel('Price ($/p.u.)')
%         legend('\lambda_{W}^E','\lambda_{19}^E','\lambda_{W}^E-dual','\lambda_{19}^E-dual')

    case 14
        pause(1e-10)
end

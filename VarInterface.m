% % VarInterface
% % =====  p.u. =======
% Pg_EH_in = sdpvar(N_Bus,NT);
% Pg_EH_out = sdpvar(N_Bus,NT);
% Pg_EHP = sdpvar(N_Bus,NT); % 10/07
% % Hg_EHP = sdpvar(N_Node,NT); % 10/07
% 
% F_Init_Interf = [];
% for i = 1:N_Bus
%     if  i ~= DataPDN.IndEH
%         F_Init_Interf = [F_Init_Interf, Pg_EH_in(i,:) == 0];
%         F_Init_Interf = [F_Init_Interf, Pg_EH_out(i,:) == 0];
%     end
% %     if  i ~= DataPDN.IndHP
% %         F_Init_Interf = [F_Init_Interf, Pg_EHP(i,:) == 0];
% %     end
% end
% % for i = 1:N_Node
% %     if  i ~= DataDHN.IndEH
% %         F_Init_Interf = [F_Init_Interf, Hg_EH(i,:) == 0];
% %     end
% %     if  i ~= DataDHN.IndHP
% %         F_Init_Interf = [F_Init_Interf, Hg_EHP(i,:) == 0];
% %     end
% % end
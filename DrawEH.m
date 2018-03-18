    figure
    subplot(3,1,1)
    plot(1:NT,Sb*value(p_gasin),'-bo');
    xlabel('time (h)')
    ylabel('P^{gas} (MW)')

    subplot(3,1,2)
    x = 0:NT; 
    y1 = [0 Sb*(value(p_char) - value(p_disc))];
    y2 = [Sb*value(E_Hub0),Sb*value(E_Hub)];
    [AX,H1,H2] = plotyy(x,y1,x,y2,'bar','plot');
    set(AX(1),'XColor','k','YColor','b');
    set(AX(2),'XColor','k','YColor','r');
    set(AX(1),'Xlim',[0,NT+1]);
    set(AX(2),'Xlim',[0,NT+1]);
    HH1=get(AX(1),'Ylabel');
    set(HH1,'String','power (MW)');
    set(HH1,'color','b');
    HH2=get(AX(2),'Ylabel');
    set(HH2,'String','energy (MWh)');
    set(HH2,'color','r');
    set(H1,'LineStyle','-');
    set(H2,'LineStyle','-');
    set(H2,'color','r');
    hh = legend([H1,H2],{'charge/discharge';'SoC of EES'});
    hh.Orientation = 'horizontal';
    xlabel('time(h)');
    
    subplot(3,1,3)
    x = 0:NT; 
    y1 = [0 Sb*(value(h_char) - value(h_disc))];
    y2 = [Sb*value(H_Hub0),Sb*value(H_Hub)];
    [AX,H1,H2] = plotyy(x,y1,x,y2,'bar','plot');
    set(AX(1),'XColor','k','YColor','b');
    set(AX(2),'XColor','k','YColor','r');
    set(AX(1),'Xlim',[0,NT+1]);
    set(AX(2),'Xlim',[0,NT+1]);
    HH1=get(AX(1),'Ylabel');
    set(HH1,'String', 'power (MW)');
    set(HH1,'color','b');
    HH2=get(AX(2),'Ylabel');
    set(HH2,'String','energy (MWh)');
    set(HH2,'color','r');
    set(H1,'LineStyle','-');
    set(H2,'LineStyle','-');
    set(H2,'color','r');
    hh = legend([H1,H2],{'charge/discharge';'SoC of TES'});
    hh.Orientation = 'horizontal';
    xlabel('time(h)');
 
    
    
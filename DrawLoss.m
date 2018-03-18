Q_Loss = Q_LossS + Q_LossR;
figure
subplot(2,1,1)
surf(Sb*Phai)
shading interp
colorbar
xlabel('Time (h)')
ylabel('Pipe no.')
zlabel('Tranported heat power (MW)')
subplot(2,1,2)
pcolor(Sb*Phai)
colorbar
xlabel('Time (h)')
ylabel('Pipe no.')

figure
subplot(3,1,1)
pcolor(Sb*Q_LossS)
xlabel('Time (h)')
ylabel('Pipe no.')
title('Q Loss S (MW)')
colorbar
subplot(3,1,2)
pcolor(Sb*Q_LossR)
xlabel('Time (h)')
ylabel('Pipe no.')
title('Q Loss R(MW)')
colorbar
subplot(3,1,3)
pcolor(100*(Q_LossS+Q_LossR)./Phai)
xlabel('Time (h)')
ylabel('Pipe no.')
title('Loss rate (%)')
colorbar


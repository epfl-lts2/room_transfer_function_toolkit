close all
load data_rf.mat

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_i, 'Linewidth', 3)
xlabel('Number of selected frequencies')
ylabel('Number of iterations')
xlim([10 inf])
ylim([0 inf])
title('Average number of iterations')
set(gca,'fontsize', 24)

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_t, 'Linewidth', 3)
xlabel('Number of selected frequencies')
ylabel('Time [s]')
xlim([10 inf])
ylim([0 inf])
title('Average reconstruction time')
set(gca,'fontsize', 24)

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_f, 'Linewidth', 3)
xlabel('Number of selected frequencies')
ylabel('Number of failures')
xlim([10 inf])
ylim([0 inf])
title('Number of failures')
set(gca,'fontsize', 24)
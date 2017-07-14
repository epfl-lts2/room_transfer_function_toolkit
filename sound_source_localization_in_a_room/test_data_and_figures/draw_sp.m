close all
load data_sp.mat

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(sp_vector, results_i, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Number of iterations')
xlim([1 inf])
ylim([0 inf])
title('Average number of iterations')
set(gca,'fontsize', 24)

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(sp_vector, results_t, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Time [s]')
xlim([1 inf])
ylim([0 inf])
title('Average reconstruction time')
set(gca,'fontsize', 24)

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(sp_vector, results_f, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Number of failures')
xlim([1 inf])
ylim([0 inf])
title('Number of failures')
set(gca,'fontsize', 24)
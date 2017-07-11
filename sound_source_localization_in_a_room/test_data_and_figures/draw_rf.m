close all
load data_rf.mat
%sp_vector = 1:15;
%results = zeros(length(sp_vector),1);   % reconstruction error
%results_i = [0 28 42 75 90 110 102 132 119 139 142 122 117 143 141]; % iteration number
%results_t = [0 3.75 4 5.6 6.2 6.7 5.4 7 5.8 6 5.9 5.3 5 5.7 5.6]; % iteration number
%results_f = [100 0 0 4 6 16 27 32 37 40 47 45 55 62 58]; % failure counter

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Reconstruction error')
xlim([10 inf])
ylim([0 inf])
title('Average reconsruction error for different source postion subsampling')
set(gca,'fontsize', 18)
%saveas(gcf,'subsampling_over_sound_source_convergence.png')
%close all

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_i, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Number of iterations')
xlim([10 inf])
ylim([0 inf])
title('Average number of iterations')
set(gca,'fontsize', 24)
%saveas(gcf,'subsampling_over_sound_source_iterations.png')
%close all

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_f, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Number of failures')
xlim([10 inf])
ylim([0 inf])
title('Number of failures')
set(gca,'fontsize', 24)
%saveas(gcf,'subsampling_over_sound_source_failures.png')
%close all

figure('units','normalized','outerposition',[0 0 1 1])
set(gcf,'color','w');
plot(rf_vector, results_t, 'Linewidth', 3)
xlabel('Subsampling level')
ylabel('Time [s]')
xlim([10 inf])
ylim([0 inf])
title('Average reconstruction time')
set(gca,'fontsize', 24)
%saveas(gcf,'subsampling_over_sound_source_times.png')
%close all
% load('a_2tone_df_1000000_n_500.mat');
% 
% correlation_coefficients = corrcoef(values_in_dBm')

frequency_separation = [100 200 500 700 1000];
correlation_coefficients = [0.8294 0.5449 -0.0131 0.1638 1.0000];

figure;
plot(frequency_separation,correlation_coefficients, 'o-');
title('Measured correlation');
xlabel('Frequency separation (kHz)');
ylabel('Correlation coefficients');
grid on;


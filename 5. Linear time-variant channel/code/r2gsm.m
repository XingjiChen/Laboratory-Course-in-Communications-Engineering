clear all;
clc

% Load the data from a .mat file
load('gsm.mat'); 

% Matched filtering
% Compute matched filter output using convolution
matched_filter_output_conv = conv(samples, conj(fliplr(seq)), 'same');

% Convert to dB for plotting
matched_filter_output_conv_db = 10 * log10(abs(matched_filter_output_conv));

% Parameters
sampling_rate = 10e6; % 10 MHz
repetition_rate = 200; % 200 Hz
total_time = 2.4; % seconds
impulse_response_length = 100; % Length of each impulse response

% Calculate the number of samples per repetition period and total number of periods
samples_per_period = sampling_rate / repetition_rate;
num_periods = floor(total_time * repetition_rate); % Total number of impulse responses

% Initialize the matrix to store impulse responses
impulse_responses = zeros(impulse_response_length, num_periods);

% Extract impulse responses using clever indexing 17620/16650
for i = 1:num_periods
    start_idx = round((i - 1) * 50000) + 17620;
    end_idx = start_idx + impulse_response_length - 1;
    impulse_responses(:, i) = matched_filter_output_conv_db(start_idx:end_idx);
end

% 计算每个抽头的平均功率（以 dB 为单位）
PDP_dB = 10 * log10(abs(impulse_responses(:, 1:50)).^2);
PDP_dB_avg = mean(PDP_dB, 2);  % 对所有时间点进行平均

% 归一化 PDP，使最强的抽头为 0 dB
PDP_dB_avg_norm = PDP_dB_avg - max(PDP_dB_avg);

% 绘制归一化的 PDP
figure;
% plot(linspace(0, 5, impulse_response_length), PDP_dB_avg_norm);
plot(linspace(0, 5, impulse_response_length), PDP_dB_avg_norm);
xlabel('Delay (μs)');
ylabel('Power (dB)');
title('Power Delay Profile');

% 计算绝对延迟扩展和 RMS 延迟扩展
% 首先将 dB 转换回线性尺度
PDP_linear = 10.^(PDP_dB_avg_norm / 10);

% 计算绝对延迟扩展
[~, idx_max] = max(PDP_linear);
abs_delay_spread = find(PDP_linear > 1e-3, 1, 'last') - idx_max;
abs_delay_spread = abs_delay_spread * (25 / impulse_response_length); 

% 计算 RMS 延迟扩展
delay = linspace(0, 0.25, impulse_response_length)' - (idx_max * (0.25 / impulse_response_length));
rms_delay_spread = sqrt(sum(PDP_linear .* delay.^2) / sum(PDP_linear));

% 输出结果
fprintf('Absolute Delay Spread: %f μs\n', abs_delay_spread);
fprintf('RMS Delay Spread: %f μs\n', rms_delay_spread * 10);
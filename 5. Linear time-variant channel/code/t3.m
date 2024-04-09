clc;
clear all;

% 加载.mat文件
load('lte.mat'); % 将'yourfile.mat'替换为你的文件名

% 计算匹配滤波器的输出
% 使用conv函数
matched_filter_output_conv = conv(samples, conj(fliplr(seq)), 'same');

% 或者使用xcorr函数
matched_filter_output_xcorr = xcorr(samples, seq);
% xcorr输出的长度会比输入长，我们需要截取中间部分以匹配原始信号的长度
len = length(samples);
start_index = floor((length(matched_filter_output_xcorr) - len) / 2) + 1;
matched_filter_output_xcorr = matched_filter_output_xcorr(start_index:start_index + len - 1);

% 选择一个输出进行绘图，这里我们用conv的结果
output_to_plot = matched_filter_output_conv;

% 转换为分贝
output_to_plot_db = 10 * log10(abs(output_to_plot));

% 绘制输出的小部分
% plot_start = 17500; % 根据需要调整
% plot_end = 18000; % 根据需要调整
plot_start = 10000; % 根据需要调整
plot_end = 100000; % 根据需要调整
plot(plot_start:plot_end, output_to_plot_db(plot_start:plot_end));
title('Matched Filter Output in dB');
xlabel('Sample Index');
ylabel('Magnitude (dB)');

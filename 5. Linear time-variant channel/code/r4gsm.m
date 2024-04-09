clear all;
clc;

% Load the data from a .mat file
load('gsm.mat'); % 确保 'gsm.mat' 文件中含有 'samples' 和 'seq'

% Matched filtering
% Compute matched filter output using convolution
matched_filter_output_conv = conv(samples, conj(fliplr(seq)), 'same');

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

% Extract impulse responses
for i = 1:num_periods
    start_idx = round((i - 1) * samples_per_period) + 17620;
    end_idx = start_idx + impulse_response_length - 1;
    impulse_responses(:, i) = matched_filter_output_conv(start_idx:end_idx);
end

% Now, impulse_responses matrix contains time-variant channel responses

% Compute the time-variant channel transfer function H(f, t)
H_f_t = fft(impulse_responses, [], 1);  % FFT along the τ dimension

% Frequency correlation function φH(Δf, 0)
phi_H_f_0 = zeros(2*impulse_response_length-1, num_periods);
for t = 1:size(H_f_t, 2)
    phi_H_f_0(:, t) = xcorr(H_f_t(:, t), 'unbiased');  % Compute autocorrelation along f axis
end
phi_H_f_0_mean = mean(phi_H_f_0, 2);  % Average along t axis
figure;
plot(abs(phi_H_f_0_mean));
title('Frequency Correlation Function φ_H(Δf, 0)');
xlabel('Frequency Shift Δf');
ylabel('Correlation');

% Time correlation function φH(0, Δt)
phi_H_0_t = zeros(size(H_f_t, 1), 2*num_periods-1);
for f = 1:size(H_f_t, 1)
    phi_H_0_t(f, :) = xcorr(H_f_t(f, :), 'unbiased');  % Compute autocorrelation along t axis
end
phi_H_0_t_mean = mean(phi_H_0_t, 1);  % Average along f axis
figure;
plot(abs(phi_H_0_t_mean));
title('Time Correlation Function φ_H(0, Δt)');
xlabel('Time Shift Δt');
ylabel('Correlation');

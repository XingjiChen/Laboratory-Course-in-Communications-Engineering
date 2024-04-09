clear all;
clc

% Load the data from a .mat file
load('lte.mat'); 

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

% Extract impulse responses using clever indexing 16650
for i = 1:num_periods
    start_idx = round((i - 1) * 50000) + 16650;
    end_idx = start_idx + impulse_response_length - 1;
    impulse_responses(:, i) = matched_filter_output_conv_db(start_idx:end_idx);
end

[T, Tau] = meshgrid(linspace(0, 2.5, num_periods), linspace(-2, 6, impulse_response_length));
% Plot the absolute value of the first 50 impulse responses using surf
figure;
surf(Tau(:, 1:50), T(:, 1:50), -abs(impulse_responses(:, 1:50)));
xlabel('τ (μs)');
ylabel('t (s)');
zlabel('Power (dB)');
title('Impulse Responses');
set(gca, 'YDir', 'reverse');
xlim([-2 6]);
ylim([0 0.25]);
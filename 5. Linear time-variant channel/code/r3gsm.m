clear all;
clc;

% Load the data from a .mat file
load('gsm.mat');  % 假设 'lte.mat' 文件中含有 'samples' 和 'seq'

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

% Extract impulse responses 17620/16650
for i = 1:num_periods
    start_idx = round((i - 1) * samples_per_period) + 17620;
    end_idx = start_idx + impulse_response_length - 1;
    impulse_responses(:, i) = matched_filter_output_conv(start_idx:end_idx);
end

% Now, impulse_responses matrix contains time-variant channel responses

% Calculating Power Delay Profile (PDP) for each impulse response
PDP = abs(impulse_responses).^2;

% Initializing Delay-Doppler function h(tau, phi)
delay_doppler_function = zeros(impulse_response_length, num_periods);

% Calculate h(tau, phi) using Fourier Transform on PDP (simplified approach)
for i = 1:impulse_response_length
    delay_doppler_function(i, :) = fft(PDP(i, :));
end

% Analyze and plot the Doppler spectrum for each channel tap
figure;
for i = 1:impulse_response_length
    plot(10 * log10(abs(delay_doppler_function(i, :))));
    hold on;
    title('Doppler Spectrum');
    xlabel('Doppler Shift');
    ylabel('Magnitude');
end

% Estimate Doppler spread (simplified estimation)
% This part is context-dependent and requires specific definitions of Doppler spread
% Here we show a basic approach to estimate the maximum Doppler frequency
doppler_spread = max(max(abs(delay_doppler_function)));
fprintf('Estimated Doppler Spread: %f Hz\n', doppler_spread);

clear
close all

% Load measurement data
f = fopen("pathloss_mux.dat", "r");
meas_mux = fread(f, 'float');
meas_mux = meas_mux(1:2:end) + 1i*meas_mux(2:2:end);
fclose(f);

RX1 = meas_mux(1:2:end-1);
RX2 = meas_mux(2:2:end);

% Remove DC offset
RX1 = RX1-mean(RX1);
RX2 = RX2-mean(RX2);


% find maximum fft bin around middle of the measurement
slice = RX1(floor(length(RX1)/2)+[-127:128]);
N_fft = length(RX1);
slice_fft = fft(slice, N_fft);
[v, l] = max(abs(slice_fft));  % l is index of fft bin with max energy

%%
% Keep signal around bin l, zero everything else.
% This removes noise.
% ch1
tmp1 = fft(RX1);
len1 = length(RX1);
select1 = [l + [-1023:1024]];
tmp2 = zeros(size(tmp1));
tmp2(select1) = tmp1(select1);
RX1_time = ifft(tmp2);
t1 = 1/1e4 * [0:(len1-1)]; 

% ch2 
tmp1 = fft(RX2);
len1 = length(RX1);
select1 = [l + [-1023:1024]];
tmp2 = zeros(size(tmp1));
tmp2(select1) = tmp1(select1);
RX2_time = ifft(tmp2);
t2 = 1/1e4 * [0:(len1-1)]; 


% time domain plot
figure()
plot(t1, 20 * log10(abs(RX1_time)))
hold on
plot(t2, 20 * log10(abs(RX2_time)))
hold off
grid on
xlabel("time/s")
ylabel("dB")
legend("RX1", "RX2")

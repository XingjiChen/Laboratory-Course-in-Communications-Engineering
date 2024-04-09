% 用于导入数据的文件名，根据实际情况更改
filename = 'wideband2tap.csv';

% 导入数据，假设头信息在前63行
a = importdata(filename, ',', 63);

% 提取数据
power_dBm = a.data;

% 获取开始和结束时间信息，这需要从文件的头部读取
% 以下代码假设您能从头信息中提取出这些数据
% 如果格式不同，请调整代码以正确解析时间信息
start_time = 1.6e-7; % 替换 ... 以从头信息中提取开始时间
stop_time = 3; % 替换 ... 以从头信息中提取结束时间
num_points = length(power_dBm); % 数据点的数量

% 计算时间轴
time_axis = linspace(start_time, stop_time, num_points);

% 绘制功率随时间变化的图
figure;
plot(time_axis, power_dBm);
xlabel('Time (s)');
ylabel('Power (dBm)');
title('Signal Power over Time');
grid on;

% 计算动态范围：最大功率与最小功率之差
dynamic_range = max(power_dBm) - min(power_dBm);

% 计算平均功率
average_power = mean(power_dBm);

% 显示动态范围和平均功率
disp(['Dynamic Range: ', num2str(dynamic_range), ' dBm']);
disp(['Average Power: ', num2str(average_power), ' dBm']);

% 使用平均功率减去 5dB 作为阈值来确定 LCR 和 AFD
threshold = average_power - 5;

% 计算穿越率和平均衰落持续时间
% 以下是计算LCR和AFD的示例代码，可能需要根据您的具体数据结构进行调整

% 计算穿越率：计算阈值上穿的次数
crossings = sum(diff(power_dBm > threshold) == 1);
level_crossing_rate = crossings / (time_axis(end) - time_axis(1));

% 计算平均衰落持续时间：找出连续低于阈值的时间段
below_threshold = power_dBm < threshold;
below_intervals = diff([0, below_threshold', 0]);
fade_durations = find(below_intervals == -1) - find(below_intervals == 1);
average_fade_duration = mean(fade_durations) / (num_points / (stop_time - start_time));

% 显示LCR和AFD
disp(['Level Crossing Rate: ', num2str(level_crossing_rate), ' crossings/s']);
disp(['Average Fade Duration: ', num2str(average_fade_duration), ' s']);


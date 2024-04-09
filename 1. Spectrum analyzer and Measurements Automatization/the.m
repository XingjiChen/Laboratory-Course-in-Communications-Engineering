t_s = 1/1800e6; %采样周期
t_start = 0.01; %起始时间
t_end = 0.02;     %结束时间
t = t_start : t_s : t_end;
y = 1.5*sin(2*pi*900e6*t);  %生成信号

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%频谱%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y_f = fft(y); %傅里叶变换

Druation = t_end -t_start;  %计算采样时间
Sampling_points = Druation/t_s +1;  %采样点数，fft后的点数就是这个数
f_s = 1/t_s; %采样频率
f_x = 0:f_s/(Sampling_points -1):f_s;  %注意这里和横坐标频率对应上了，频率分辨率就是f_s/(Sampling_points -1)
t2 = f_x-f_s/2;
shift_f = abs(fftshift(y_f));

plot(f_x,abs(y_f));
grid on;
axis([850e6 950e6 0 0.1])
set(gca,'ytick',[])

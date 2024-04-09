f1 = 2400;
f2 = 5800;
x = [0:0.1:10];
d = sqrt(x.^2-8.6.*x+43.49);
PL1 = 20.*log10(d)+20.*log10(f1)-27.55;
PL2 = 20.*log10(d)+20.*log10(f2)-27.55;
LB1 = 10+10-PL1;
LB2 = 10+0-PL2;

figure;
plot(x,PL1)
grid on;
title('Path loss (f = 2.4 GHz)')
xlabel('moving distance')
ylabel('dB')

figure;
plot(x,PL2)
grid on;
title('Path loss (f = 5.8 GHz)')
xlabel('moving distance')
ylabel('dB')

figure;
plot(x,LB1)
grid on;
title('Link budget (f = 2.4 GHz)')
xlabel('moving distance')
ylabel('dBm')

figure;
plot(x,LB2)
grid on;
title('Link budget (f = 5.8 GHz)')
xlabel('moving distance')
ylabel('dBm')
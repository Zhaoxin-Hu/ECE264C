clc
clf
close all
clearvars

N = 100; % Number of segments
M = 1000; % Length of segment
L = 10000; % FFT length
data = randn(N*M,1);
for i = 1:N
    x(1:M,i) = data((i-1)*M+1:i*M);
    x_per(1:L,i) = 1/M*abs(fft(x(1:M,i),L)).^2;
end
per = mean(x_per,2);
x_ax = linspace(0,1,L);
figure
plot(x_ax,pow2db(per))
xlim([0,0.5])
ylim([-10,10])
xlabel('Normalized frequency')
ylabel('PSD (dB)')
figure
plot(x_ax,per)
xlim([0,0.5])
ylim([0,10])
xlabel('Normalized frequency')
ylabel('PSD')
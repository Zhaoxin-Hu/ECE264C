clc
clf
close all
clearvars

M = 100; % Length of segment
L = 256; % FFT length
x = randn(M,1);
per = 1/M*abs(fft(x,L)).^2;
x_ax = linspace(0,1,L);
figure
plot(x_ax,pow2db(per))
xlim([0,0.5])
xlabel('Normalized frequency')
ylabel('PSD (dB)')
figure
periodogram(x);
pxx = periodogram(x);
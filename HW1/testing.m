clc
clf
close all
clearvars

fs = 1000; % Sample rate
M = 100; % Length of segment
L = 1000; % FFT length
hann = 0.5*(1-cos(2*pi*[1:M]/(M-1)));
hann_psd = 1/M*abs(fft(hann,L)).^2;
x_ax = linspace(0,1,L)*fs;
plot(x_ax,pow2db(hann_psd))
xlim([0,0.5]*fs)
xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')
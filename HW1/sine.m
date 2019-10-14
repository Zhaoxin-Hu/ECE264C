clc
clf
close all
clearvars

N = 10; % Number of segments
M = 100; % Length of segment
L = 10000; % FFT length
y = sin(2*pi*0.3*[1:N*M]+0.2);%+rand(N*M);
for i = 1:N
    x(1:M,i) = y((i-1)*M+1:i*M);
    x_per(1:L,i) = 1/M*abs(fft(x(1:M,i),L)).^2;
end
per = mean(x_per,2);
x_ax = linspace(0,1,L);
figure
plot(x_ax,pow2db(per))
xlim([0,0.5])
ylim([-10,15])
xlabel('Normalized frequency')
ylabel('PSD (dB)')
figure
plot(x_ax,per)
xlim([0,0.5])
% ylim([0,10])
xlabel('Normalized frequency')
ylabel('PSD')

pwr = sum(per)/L;
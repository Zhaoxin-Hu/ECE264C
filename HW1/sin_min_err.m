clc
clf
close all
clearvars

N = 500; % Number of segments
M = 1001; % Length of segment
fs = 1000; % Sampling frequency
fsig = 300; % Signal frequency
y = sin(2*pi*fsig/fs*[1:N*M]+0.2)+2*randn(1,N*M); % Data sequence
nfft = 5000; % FFT length
W = exp(1j*2*pi*fsig/fs);
a11 = (1-W^(2*N*M))/(1-W^2);
a12 = N*M;
a21 = N*M;
a22 = (1-W^(-2*N*M))/(1-W^(-2));
b1 = sum(y.*(W.^[1:N*M]));
b2 = sum(y.*(W.^[-1:-1:-N*M]));
A = [a11,a12;a21,a22];
B = [b1;b2];
Y_hat = linsolve(A,B);
a1 = 2*abs(Y_hat(1));
phi1 = angle(Y_hat(1));

% Separate the signal from noise, and estimate powers.
y_hat = a1*cos(2*pi*0.3*[1:N*M]+phi1);
e = y-y_hat;
y_hat_pwr = mean(y_hat.^2);
e_pwr = mean(e.^2);
disp(sprintf("The estimated mean square of the signal is %.2f.",y_hat_pwr))
disp(sprintf("The estimated mean square of the noise is %.2f.",e_pwr))

% Estimate the PSD for signal and noise.
e = e-mean(e); % Mean removal
U = mean(hanning(M).^2); % Normalization factor
for i = 1:N
    y_hat_seg(i,1:M) = y_hat((i-1)*M+1:i*M);
    Y_PER_seg(i,1:nfft) = 1/M/U*abs(fft(y_hat_seg(i,1:M).*hanning(M).',nfft)).^2;
    e_seg(i,1:M) = e((i-1)*M+1:i*M);
    E_PER_seg(i,1:nfft) = 1/M/U*abs(fft(e_seg(i,1:M).*hanning(M).',nfft)).^2;
end
Y_PER = mean(Y_PER_seg);
E_PER = mean(E_PER_seg);
f = linspace(0,1,nfft);
figure()
semilogx(f,pow2db(Y_PER))
xlim([0.01,0.5])
% ylim([-50,30])
xlabel('Normalized frequency (f/f_s)')
ylabel('PSD (dB)')
title('PSD estimate of the signal')
figure()
semilogx(f,pow2db(E_PER))
xlim([0.01,0.5])
% ylim([-5,5])
xlabel('Normalized frequency (f/f_s)')
ylabel('PSD (dB)')
title('PSD estimate of the noise')
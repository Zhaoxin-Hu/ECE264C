% Compare periodogram and modified periodogram.
% Galton is right about the normalization in modified periodogram.
clc
clf
close all
clearvars

N = 1000;
M = 1000;
U = mean(hanning(M).^2);
nfft = 10000;
data = randn(1,N*M);
for i = 1:100
    x(i,1:M) = data((i-1)*M+1:i*M);
    XPER(i,1:nfft) = 1/M*abs(fft(x(i,1:M),nfft)).^2;
    XMPER(i,1:nfft) = 1/M/U*abs(fft(x(i,1:M)*hanning(M),nfft)).^2;
end
XPSD = mean(XPER);
XMPSD = mean(XMPER);
f = linspace(0,2,nfft);
figure()
plot(f,pow2db(abs(XPSD)))
xlabel('Normalized frequency (rad/sample)')
ylabel('Periodogram estimate of PSD (dB/(rad/sample))')
xlim([0,1])
figure()
plot(f,pow2db(abs(XMPSD)))
xlabel('Normalized frequency (rad/sample)')
ylabel('Modified periodogram estimate of PSD (dB/(rad/sample))')
xlim([0,1])
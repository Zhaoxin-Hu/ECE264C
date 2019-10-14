% Compare periodogram and autocorrelation.
clc
clf
close all
clearvars

N = 2;
M = 1000;
nfft = 10000;
data = randn(1,N*M);

for i = 1:N
    temp = data((i-1)*M+1:i*M);
    xCORRseg(i,1:2*M-1) = conv(temp,fliplr(temp));
    XPERseg(i,1:nfft) = 1/M*abs(fft(temp,nfft)).^2;
end
for i = -M+1:M-1
    apod(i+M) = M-abs(i);
end
xCORR = mean(xCORRseg).*apod;
XCORRPSD = abs(fft(xCORR, nfft));
XPER = mean(XPERseg);
f = linspace(0,2,nfft);
figure()
plot(f,pow2db(abs(XPER)))
xlabel('Normalized frequency (rad/sample)')
ylabel('Periodogram estimate of PSD (dB/(rad/sample))')
xlim([0,1])
figure()
plot(f,pow2db(abs(XCORRPSD)))
xlabel('Normalized frequency (rad/sample)')
ylabel('PSD estimate from autocorrelation (dB/(rad/sample))')
xlim([0,1])
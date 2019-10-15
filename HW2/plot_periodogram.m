% This function takes a data sequence assumed to be of the form
% x[n] = A*sin(2*pi*f_signal/f_s*n + initial_phase) + e[n],
% where e[n] is noise, plots discrete-time PSD estimates of its
% sinusoid and noise components using the averaged periodograms
% method, and returns the estimated mean squared values of these two
% components. The spectral estimation is performed by partitioning the
% data sequence into segments, generating a periodogram for each segment
% using the Hanning window, and averaging the periodograms. The extraction
% of the sinusoid and noise components of the signal is performed with
% the sinusoidal minimum error method.
% The function takes as inputs the data sequence, the periodogram length,
% the number of segments to use, f_signal, and f_s.

function [sinusoid_power, data_minus_sinusoid_power] = plot_periodogram(data,...
    periodogram_length, num_segments, f_signal, f_s)

window = hanning(periodogram_length);
fft_of_window = fft(window);
psd_of_data_minus_sinusoid = zeros(periodogram_length, 1);
psd_of_sinusoid = zeros(periodogram_length, 1);
U = mean(window.^2);
f_normalized = f_signal / f_s;
% Average num_segments periodograms of length periodogram_length to
% estimate PSDs of data
for k = 1: num_segments
     data_segment = data(1 + (k-1)*periodogram_length:k*periodogram_length);

 [windowed_sinusoid, windowed_data_minus_sinusoid] = remove_sinusoid(data_segment, window, f_normalized);

 fft_of_sinusoid = fft(windowed_sinusoid);
 fft_of_data_minus_sinusoid = fft(windowed_data_minus_sinusoid);
 data_minus_sinusoid_periodogram = abs((fft_of_data_minus_sinusoid).^2)/ (U * periodogram_length);
 sinusoid_periodogram = abs((fft_of_sinusoid).^2) / (U *periodogram_length);
 psd_of_data_minus_sinusoid = psd_of_data_minus_sinusoid +data_minus_sinusoid_periodogram;
 psd_of_sinusoid = psd_of_sinusoid +sinusoid_periodogram;

end
psd_of_data_minus_sinusoid = psd_of_data_minus_sinusoid /num_segments;
psd_of_sinusoid = psd_of_sinusoid / num_segments;
% Compute signal power
sinusoid_power = sum(psd_of_sinusoid(1:periodogram_length) / periodogram_length);
data_minus_sinusoid_power = sum(psd_of_data_minus_sinusoid(1:periodogram_length) / periodogram_length);
% Convert PSDs to units of dB / Hz (note that it is only necessary to plot
% half of the PSD)
epsilon = 1e-20; % A really tiny number to avoid taking log of zero when converting to dB
sinusoid_spectrum = 10*log10(psd_of_sinusoid(1:periodogram_length/2) + epsilon);
data_minus_sinusoid_spectrum =10*log10(psd_of_data_minus_sinusoid(1: periodogram_length/2) + epsilon);
% Generate a frequency array to plot the PSDs against
f = zeros(1, periodogram_length/2);
for k = 1:periodogram_length/2
 f(k) = (k-1)/(periodogram_length);
end
% Plot the PSDs
figure
semilogx(f, sinusoid_spectrum)
title('Sinusoid Spectrum')
ylabel('dB/Hz')
xlabel('Normalized frequency')
figure
semilogx(f, data_minus_sinusoid_spectrum)
title('Data Minus Sinusoid Spectrum')
ylabel('dB/Hz')
xlabel('Normalized frequency')
grid;
zoom;

end
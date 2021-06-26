function [lat_s,lat_lag] = mesureLatency(aPR, in, out)

T  = 1;                 % time of the burst
f0 = 1e3;               % burst main frequency
SR = aPR.SampleRate;
buffer = str2double(aPR.BufferSize);

aPR.RecorderChannelMapping = in;
aPR.PlayerChannelMapping   = out;

t  = (0:1/SR:T-1/SR)';  % time axis

% burst signal
t_burst = T/100;
burst = 0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));

N_buffers = ceil(size(burst,1)/buffer)+1;

signal = zeros(N_buffers * buffer, 1);
signal(1:size(burst,1), :) = burst';

audioFromDevice = zeros(size(signal,1),1);
underruns = 0;
overruns = 0;

for k = 1:N_buffers
    [audioFromDevice((k-1)*buffer+1:k*buffer,:),un,ov] = aPR(signal((k-1)*buffer+1:k*buffer,:));
    underruns = underruns + un;
    overruns = overruns + ov;
end

[temp,idx] = xcorr(signal,audioFromDevice(underruns+overruns+1:end));
rxy = abs(temp);

[~,Midx] = max(rxy);
lat_s = -idx(Midx)*1/SR;
lat_lag = -idx(Midx);

end
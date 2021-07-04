%% mesureLatency.m
% Fonction de mesure par carte son
% --- ENTREE ---
% aPR (obj) : obj audioPlayerRecorder MATLAB
% in (int) : entrée loopback
% out (int) : sortie loopback
% --- SORTIE ---
% lat_s (double) : latence en seconde
% lat_lag (int) : latence en échantillon
% --- CREDIT ---
% v1.0 26/06/2021
% GUIPAG
% GPL-3.0 License

function [lat_lag,lat_s] = mesureLatency(aPR, in, out)

T  = 1;                 % time of the burst
f0 = 1e3;               % burst main frequency
SR = aPR.SampleRate;
buffer = aPR.BufferSize;

nbIn = aPR.RecorderChannelMapping;
nbOut = aPR.PlayerChannelMapping;

%% Création du burst
t  = (0:1/SR:T-1/SR)';  % time axis
t_burst = T/100;
burst = 0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));

%% Création du signal d'émission en mettant à 0 toutes les voies inutilisées
N_buffers = ceil(size(burst,1)/buffer)+1;

signal = zeros(N_buffers * buffer, length(nbOut));
signal(1:size(burst,1), find(nbOut == out)) = burst';

%% Initialisations du vecteur d'enregistrement
audioFromDevice = zeros(size(signal,1), length(nbIn));
underruns = 0;
overruns = 0;

%% Boucle de mesure
for k = 1:N_buffers
    [audioFromDevice((k-1)*buffer+1:k*buffer,:),un,ov] = aPR(signal((k-1)*buffer+1:k*buffer,:));
    underruns = underruns + un;
    overruns = overruns + ov;
end

%% Intercorrélation et mesure de la latence
[temp,idx] = xcorr(signal(:,find(nbOut == out)),audioFromDevice(underruns+overruns+1:end,find(nbIn == in)));
rxy = abs(temp);

[~,Midx] = max(rxy);
lat_s = -idx(Midx)*1/SR;
lat_lag = -idx(Midx);

end
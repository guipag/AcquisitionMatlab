%% makeMesurement.m
% Fonction de mesure par carte son
% --- ENTREE ---
% aPR (obj) : obj audioPlayerRecorder MATLAB
% nbInput (int) : nombre d'entrée initialisées
% lat_lag (int) : latence de la carte son en échantillons
% in (mat) : signal à émettre, une colonne par sortie
% --- SORTIE ---
% out (mat) : matrice contenant les signaux enregistrés, une colonne par
% entrée, la longueur des signaux est un multiple du buffer de la carte son
% --- CREDIT ---
% v1.0 26/06/2021
% GUIPAG
% GPL-3.0 License

function out = makeMesurement(aPR,nbInput,lat_lag,in)

buffer = aPR.BufferSize;

N_buffers = ceil(size(in,2)/buffer)+1;

signal = zeros(N_buffers * buffer, size(in,1));
signal(1:size(in,2), :) = in';

audioFromDevice = zeros(size(signal,1),nbInput);

%% Boucle de mesure
for k = 1:N_buffers
    [audioFromDevice((k-1)*buffer+1:k*buffer,:),numUnderrun(k),numOverrun(k)] = aPR(signal((k-1)*buffer+1:k*buffer,:));
end

%% Correction des signaux pour enlever la latence
out = zeros(size(signal,1)+lat_lag,nbInput);
out(size(signal,1),:) = circshift(audioFromDevice,-lat_lag);

end
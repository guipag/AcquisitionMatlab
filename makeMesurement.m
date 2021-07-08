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

function [out,numUnderrun,numOverrun] = makeMesurement(aPR,nbInput,lat_lag,in,withTrig,reset)

if nargin < 6
    reset = false;
end

buffer = aPR.BufferSize;
N_buffers = ceil(size(in,2)/buffer)+1;

%% création du trigger
t_trig = 0.1; %s
n_trig = t_trig*aPR.SampleRate;
%N_buffers_trig = ceil(n_trig/buffer)+1;
trig = zeros(N_buffers * buffer+buffer,1);
trig(buffer:n_trig+1) = 1; % signal créneau

%% création du signal de sortie
signal = zeros(N_buffers * buffer+buffer, size(in,1)+3); % on ajoute 1 buffer supplémentaire, la sortie trigger et la compensation latence
signal(1:size(in,2), 1:size(in,1)) = in';
signal = circshift(signal,buffer); % zero-padding au départ

if withTrig
    signal(:,end-1) = trig;
end
if reset
    signal(:,end-2) = trig;
end
%% initialisation des variables I/O
audioFromDevice = zeros(size(signal,1),nbInput+1);
numUnderrun = zeros(N_buffers,1);
numOverrun = zeros(N_buffers,1);

%% Boucle de mesure
for k = 1:N_buffers
    [audioFromDevice((k-1)*buffer+1:k*buffer,:),numUnderrun(k),numOverrun(k)] = aPR(signal((k-1)*buffer+1:k*buffer,:));
end

%% Correction des signaux pour enlever la latence
%out = zeros(size(signal,1)+lat_lag,nbInput);
out = circshift(audioFromDevice,-lat_lag); %compensation de la latence

end
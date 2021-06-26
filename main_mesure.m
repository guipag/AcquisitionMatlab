clear all

% Module d'acquisition MATLAB pour v > 2016
% Toolbox Signal Processing nécessaire
% 
% Créé par Guilhem PAGES
% v1.0 de juin 2021

%% Configuration

[aPR,sampleRate,buffer,nbInput,nbOutput,device,trigger,lbIn,lbOut] = configuration();

%% Mesure de la latence en s et lag
[lat_s,lat_lag] = mesureLatency(aPR,lbIn,lbOut);

%% Confirmation du lancement de la mesure 
% prompt "Lancer la mesure"
choixMesure = questdlg('Lancer la mesure ?', ...
	'Mesure', ...
	'Oui','Non','Non');

if choixMesure == "Non"
    return
end

%% Génération des signaux

% synchronize on burst signal
T  = 1;                 % time of the burst
f0 = 1e3;               % burst main frequency
t  = (0:1/sampleRate:T-1/sampleRate)';  % time axis

% burst signal
t_burst = T/100;
burst = zeros(nbOutput,length(t));
for ii = 1:nbOutput
    burst(ii,:) = 0.8*randn(1,length(t));%0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));
end
%burst(str2double(nbOutput)+1,:) = 0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));

%% Boucle de mesure

mesurement = makeMesurement(aPR,nbInput,lat_lag,burst);

%% Affichage
figure
plot(signal)
hold on
plot(mesurement)
legend('Output','Input')

%% Fermeture de la carte son
% release(handle_audio_player)
% release(handle_audio_recorder)
release(aPR)

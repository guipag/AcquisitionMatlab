clear all

% Module d'acquisition MATLAB pour v > 2016
% Toolbox Signal Processing nécessaire
% 
% Créé par Guilhem PAGES
% v1.0 de juin 2021

%% Configuration

% app = configGUI();
% waitfor(app,'validation',true);
% 
% nbInput = app.NombreentresSpinner.Value;
% nbOutput = app.NombresortiesSpinner.Value;
% device = app.CartesonDropDown.Value;
% sampleRate = str2double(app.FeDropDown.Value);
% buffer = str2double(app.BufferDropDown.Value);
% 
% if app.ActivertriggerCheckBox.Value
%     trigger = app.VoietriggerSpinner.Value;
% end
% if app.CompenserlatenceCheckBox.Value
%     lbIn = app.LoopbackinSpinner.Value;
%     lbOut = app.LoopbackoutSpinner.Value;
% end
% 
% aPR = audioPlayerRecorder('Device',device,...
%     'SampleRate',sampleRate,...
%     'BufferSize',buffer);
% 
% aPR.BitDepth = '32-bit float';
% aPR.RecorderChannelMapping = 1:nbInput;
% aPR.PlayerChannelMapping = 1:nbOutput;
% 
% if app.CompenserlatenceChaeckBox
%     aPR.RecorderChannelMapping(end+1) = lbIn;
%     aPR.PlayerChannelMapping(end+1) = lbOut;
% end
% if app.ActivertriggerCheckBox.Value
%     aPR.PlayerChannelMapping(end+1)   = trigger;
% end


%% Mapping SC par objet

SC = SoundCard();
SC = SC.configure();
SC = SC.compenseLatency();

SC.onlyTrigger();

%% Confirmation du lancement de la mesure 
% prompt "Lancer la mesure"
if questdlg('Lancer la mesure ?','Mesure','Oui','Non','Non') == "Non"
    return
end

%% Génération des signaux

T  = 1;                 % time of the burst
f0 = 1e3;               % burst main frequency
t  = (0:1/SC.sampleRate:T-1/SC.sampleRate)';  % time axis

% burst signal
t_burst = T/100;
burst = zeros(SC.nbOutput,length(t));
for ii = 1:SC.nbOutput
    sig_temp = 0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));%0.5*mls(length(t));
    burst(ii,:) = sig_temp(1:length(t));%0.5*real(exp(-(1000*(t-t_burst)).^2 + 1i*2*pi*f0*t));
end

%% Mesure

mesurement = SC.mesure(burst);

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

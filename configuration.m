function [aPR, sampleRate,buffer,nbInput,nbOutput,device,trigger,lbIn,lbOut] = configuration()

choixConf = questdlg('Reprendre la même configuration ?', ...
    'Configuration', ...
    'Oui','Non','Non');

switch choixConf
    case 'Oui'
        load('properties.mat');
    case 'Non'
        deviceReader = audioPlayerRecorder;
        lstSC = getAudioDevices(deviceReader);
        
        [indx,tf] = listdlg('PromptString',{'Choisir la carte son :',...
            'Only one file can be selected at a time.',''},...
            'SelectionMode','single','ListString',lstSC);
        
        prompt = {'Fréquence d échantillonnage :','Buffer :','Nb input :','Nb output :','Trigger','Loopback out :','Loopback in :'};
        dlgtitle = 'Paramètres';
        dims = [1 35];
        definput = {'48000','128','1','1','24','193','193'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        
        sampleRate = str2double(answer{1});
        buffer = str2double(answer{2});
        nbInput = str2double(answer{4});
        nbOutput = str2double(answer{3});
        device = lstSC{2};
        trigger = str2double(answer{5});
        lbIn = str2double(answer{7});
        lbOut = str2double(answer{6});
        
        prop.sampleRate = sampleRate;
        prop.buffer = buffer;
        prop.nbInput = nbInput;
        prop.nbOutput = nbOutput;
        prop.device = lstSC{2};
        prop.trigger = trigger;
        prop.lbIn = lbIn;
        prop.lbOut = lbOut;
        
        save('properties.mat','-struct','prop');
end

aPR = audioPlayerRecorder('Device',device,...
    'SampleRate',sampleRate,...
    'BufferSize',buffer);

aPR.BitDepth = '32-bit float';
aPR.RecorderChannelMapping = 1:nbInput;
aPR.PlayerChannelMapping   = 1:nbOutput;

choixMesure = questdlg('Lancer la fenêtre de configuration ASIO ?', ...
	'ASIO', ...
	'Oui','Non','Non');

if choixMesure == "Oui"
    asiosettings(device)
end

end
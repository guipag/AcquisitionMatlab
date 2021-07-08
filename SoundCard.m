classdef SoundCard
    properties
        aPR
        lbIn
        lbOut
        sampleRate
        buffer
        nbInput
        nbOutput
        device
        trigger
        trigger_reset
        lat_lag
        lat_s
    end
    
    methods
        function obj = SoundCard()
            obj.lat_lag = 0;
            obj.lat_s = 0;
            obj.sampleRate = '48000';
            obj.buffer = '128';
            obj.nbInput = '1';
            obj.nbOutput = '1';
            obj.trigger = '24';
            obj.trigger_reset = '23';
            obj.lbOut = '193';
            obj.lbIn = '193';
        end
        
        function obj = configure(obj,sampleRate,buffer,nbInput,nbOutput,trigger,lbIn,lbOut)
            if nargin > 1
                [obj.aPR,obj.sampleRate,obj.buffer,obj.nbInput,obj.nbOutput,obj.device,obj.trigger,obj.lbIn,obj.lbOut] = configuration(sampleRate,buffer,nbInput,nbOutput,trigger,lbIn,lbOut);
            else
                [obj.aPR,obj.sampleRate,obj.buffer,obj.nbInput,obj.nbOutput,obj.device,obj.trigger,obj.lbIn,obj.lbOut] = configuration(obj.sampleRate,obj.buffer,obj.nbInput,obj.nbOutput,obj.trigger,obj.lbIn,obj.lbOut);
            end
        end
        
        function [out,numUnderrun,numOverrun] = mesure(obj,in,trig)
            if nargin < 2
                trig = false;
            end
            [out,numUnderrun,numOverrun] = makeMesurement(obj.aPR,obj.nbInput,obj.lat_lag,in,trig,false);
        end
        
        function obj = compenseLatency(obj)
            [obj.lat_lag,obj.lat_s] = mesureLatency(obj.aPR, obj.lbIn, obj.lbOut);
        end
        
        function onlyTrigger(obj)
            obj.mesure(zeros(obj.sampleRate, obj.nbOutput)',true); %mesure vide d'1s ...
        end
        
        function resetPosition(obj)
            makeMesurement(obj.aPR,obj.nbInput,obj.lat_lag,zeros(obj.sampleRate, obj.nbOutput)',false,true);
        end
        
        function assioSettings(obj)
            asiosettings(obj.device)
        end
        
        function info(obj)
            info(obj.aPR)
        end
        
        function nbIn = nbRecorderChannel(obj)
            nbIn = length(obj.aPR.RecorderChannelMapping);
        end
        
        function nbOut =  nbPlayerChannel(obj)
            nbOut = length(obj.aPR.PlayerChannelMapping);
        end
        
        function delete(obj)
            release(obj.aPR)
        end
    end
end
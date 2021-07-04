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
        lat_lag
        lat_s
    end
    
    methods
        function obj = SoundCard()
            obj.lat_lag = 0;
            obj.lat_s = 0;
        end
        
        function obj = configure(obj)
            [obj.aPR,obj.sampleRate,obj.buffer,obj.nbInput,obj.nbOutput,obj.device,obj.trigger,obj.lbIn,obj.lbOut] = configuration();
        end
        
        function [out,numUnderrun,numOverrun] = mesure(obj,in)
            [out,numUnderrun,numOverrun] = makeMesurement(obj.aPR,obj.nbInput,obj.lat_lag,in);
        end
        
        function obj = compenseLatency(obj)
            [obj.lat_lag,obj.lat_s] = mesureLatency(obj.aPR, obj.lbIn, obj.lbOut);
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
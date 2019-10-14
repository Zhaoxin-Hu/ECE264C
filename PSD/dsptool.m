classdef dsptool
    properties
        data
        len
        fs
        numtone
        tones
        maxharms
    end
    methods
        function obj = dsptool(data,fs,numtone,tones,maxharms)
            obj.data = data;
            obj.length = length(obj.data);
            obj.fs = fs;
            obj.tones = tones;
            obj.maxharms = maxharms;
            W = exp()
        end
    end
end
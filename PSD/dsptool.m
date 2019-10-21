classdef dsptool < handle
    properties
        parser % Input parser
        dataSeq % Data sequence
        type % Type of analysis
        len % Length of data sequence
        M % Segment length
        N % Number of segments
        fsig % Signal frequency        
        fs % Sampling frequency       
        harmIdx % Harmonic indices
        win % Window
        winType % Window type
        U % Normalization factor of the window
        nfft % FFT length
        sig % Extracted signal component
        segment % Data segment matrix
        perSeg % Matrix of periodograms of segments
        perAvg % Average of periodograms
        noise % Extracted noise component
    end
    methods
        function obj = dsptool(data,varargin)
            % Create an input parser.
            obj.parser = inputParser();
            % Define default input values, valid input value sets, and input validation functions.
            defaultType = 'PSD';
            validType = {'PSD','sinMinErrPSD'};
            checkType = @(x) any(validatestring(x,validType));
            
            defaultM = 100;
            defaultN = 10;           
            defaultLen = defaultM*defaultN;
            defaultnfft = 2^(nextpow2(defaultM)+1);
            defaultFsig = 100;
            defaultFs = 1000;
            defaultHarmIdx = [1,2,3];
            validScalarPosNum = @(x) isnumeric(x) & isscalar(x) & (x>0);
            validNonnegInt = @(x) isequal(x,floor(x)) & isempty(x(x<0));
            validScalarPosInt = @(x) isequal(x,floor(x)) & isscalar(x) & isempty(x(x<=0));
            
            defaultWinType = 'hanning';
            
            % Add the required and parametric inputs to the parser.
            obj.parser.addRequired('dataSeq',@isnumeric)
            obj.parser.addParameter('type',defaultType,checkType)
            obj.parser.addParameter('winType',defaultWinType,@isstring);
            obj.parser.addParameter('segLen',defaultM,validScalarPosInt);
            obj.parser.addParameter('numSeg',defaultN,validScalarPosInt);
            obj.parser.addParameter('nfft',defaultnfft,validScalarPosInt);
            obj.parser.addParameter('fsig',defaultFsig,validScalarPosNum);
            obj.parser.addParameter('fs',defaultFs,validScalarPosNum);
            obj.parser.addParameter('harmIdx',defaultHarmIdx,validNonnegInt);
            
            % Finish defining the parser.
            obj.parser.parse(data,varargin{:});
            
            % Initialize properties
            obj.M = obj.parser.Results.segLen;
            obj.N = obj.parser.Results.numSeg;
            obj.len = obj.M*obj.N;
            % Convert the input data to a row vector.
            if ~isvector(obj.parser.Results.dataSeq)
                warning('The input is a matrix. It is reshaped to a row vector!')
                obj.dataSeq = obj.parser.Results.dataSeq(1:end);
            elseif iscolumn(obj.parser.Results.dataSeq)
                warning('The input is a column vector. It is reshaped to a row vector!')
                obj.dataSeq = obj.parser.Results.dataSeq.';
            elseif isrow(obj.parser.Results.dataSeq)
                obj.dataSeq = obj.parser.Results.dataSeq;
            end
            % Truncate or zero-pad the input data.
            if length(obj.dataSeq) > obj.len
                warning(sprintf("The input data sequence is truncated to have a length of %d * %d!",obj.M,obj.N))
                obj.dataSeq = obj.dataSeq(1:obj.len);
            elseif length(obj.dataSeq) < obj.len
                warning(sprintf("The input data sequence is zero-padded to have a length of %d * %d!",obj.M,obj.N))
                obj.dataSeq = [obj.dataSeq,zeros(1,obj.len-length(obj.dataSeq))];
            end     
            obj.type = obj.parser.Results.type;            
            if strcmp(obj.type,'sineMinErrPSD')
                obj.fsig = obj.parser.Results.fsig;
                obj.fs = obj.parser.Results.fs;
                obj.harmIdx = obj.parser.Results.harmIdx;
            end            
            obj.winType = obj.parser.Results.winType;
            obj.win = eval(sprintf("%s(%d)",obj.winType,obj.M));
            if iscolumn(obj.win)
                obj.win = obj.win.';
            end
            obj.U = sum(obj.win.^2);
            % Initialize nfft
            if obj.parser.Results.nfft < 2^(nextpow2(obj.M)+1)
                obj.nfft = 2^(nextpow2(obj.M)+1);
                warning("The FFT length is increased to %d!",obj.nfft)
            else
                obj.nfft = obj.parser.Results.nfft;
            end
            obj.segWin();
        end
       
        function segWin(obj)
            % Segmentize the input data sequence into a matrix with each
            % row being a segment, and multiply each row with the window.
%             obj.segment = zeros(obj.N,obj.M);
            for i = 1:obj.N               
                obj.segment(i,1:obj.M) = obj.dataSeq((i-1)*obj.M+1:i*obj.M).*obj.win;
            end
        end

        function plotPSD(obj)
            for i = 1:obj.N               
                obj.perSeg(i,1:obj.nfft) = 1/(obj.M*obj.U)*abs(fft(obj.segment(i,1:obj.M),obj.nfft)).^2;
            end
            if obj.N ~= 1
                obj.perAvg = mean(obj.perSeg);
            else
                obj.perAvg = obj.perSeg;
            end
            f_ax = linspace(0,1-1/obj.nfft,obj.nfft);
            figure()
            plot(f_ax,pow2db(obj.perAvg))
            xlim([0,0.5])
            xlabel('Normalized frequency (\times 2\pi rad/sample)')
            ylabel('Power/frequency (dB)')
            title('Periodogram (Two-Sided)')
        end
    end
end
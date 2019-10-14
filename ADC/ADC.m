classdef ADC
    properties
        delta
        numlvl
        lobound
        upbound
    end
    methods
        function obj = ADC(delta,numlvl,varargin)
            if nargin == 1
                obj.delta = delta;
                obj.nbins = 50;
                obj.lobound = -inf;
                obj.upbound = inf;
            elseif nargin == 2
                obj.delta = delta;
                obj.numlvl = numlvl;
                obj.lobound = -floor(obj.numlvl/2);
                if mod(obj.numlvl,2) % The number of levels is an odd number.
                    obj.upbound = floor(obj.numlvl/2);
                else % The number of levels is an even number.
                    obj.upbound = floor(obj.numlvl/2)-1;
                end
            else
                obj.delta = delta;
                error('The input should only be the quantization step!')
            end
        end
        function out = quant(obj,x)
            out = floor(x/obj.delta+0.5)*obj.delta;
            if ~isinf(obj.numlvl)
                out(out<obj.lobound) = obj.lobound;
                out(out>obj.upbound) = obj.upbound;
            end
        end
        function e = quant_err(obj,x)
            e = obj.quant(x)-x;
        end
        function plot(obj,varargin)
            if nargin == 1
                ip = -4.5:0.01:4.5;
                e = obj.quant_err(ip);
                figure()
                plot(ip,e)
                xlim([ip(1),ip(end)])
                % ylim([-obj.delta,obj.delta])
                axis equal
                xlabel('Input (x)')
                ylabel('Quantization error (e_q)')
                title('Quantization Error vs Input')
            elseif nargin == 2
                ip = varargin{1};
                op = obj.quant(ip);
                e = obj.quant_err(ip);
                figure()
                
                subplot(2,1,1)
                plot([0:length(ip)-1],ip)
                hold on
                plot([0:length(op)-1],op)
                hold off
                xlim([0,length(ip)-1])
                ylim([min(min(ip),min(op)),max(max(ip),max(op))])
                xlabel('Index')
                ylabel('Value')
                legend('Input','Output','Location','bestoutside')
                title('Input and Output')
                
                subplot(2,1,2)
                plot([0:length(ip)-1],ip)
                hold on
                plot([0:length(e)-1],e)
                hold off
                xlim([0,length(ip)-1])
                ylim([min(min(ip),min(e)),max(max(ip),max(e))])
                xlabel('Index')
                ylabel('Value')
                legend('Input','Error','Location','bestoutside')
                title('Input and Quantization Error')
            else
                error('The input should only be the input sequence!')
            end
            
        end
    end
end
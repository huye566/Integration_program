function myplot_analysis_batch(varargin) 
% myplot_analysis_batch(data,type,fs,method,control_m,fig_add,base_noise) 
%type=1--仅自相关
%type=2--仅互相关
%type=3--仅频域
%type=4--仅时域和频域
%type=5--时域频域和自相关
%range指绘制数据范围
%method=1标准频谱，
%method~=1较为真实信号频谱
%data长度小于fs时不会处理
%control_m=1,正常结果，else可调节
% if length(data)>=2e7
% data=data(1:2e7);
% end
if nargin<6||nargin>7
    disp('the num of variable Value is error!');
    return;
end
data=varargin{1};
type=varargin{2};
fs=varargin{3};
method=varargin{4};
control_m=varargin{5};
fig_add=varargin{6};
if nargin==7
    base_noise=varargin{7};
end
switch(type)
    case 1        
        [auto_corr_data,~]=autocorr(data,length(data)-1);
        if control_m==1
        figure(2);
        plot(auto_corr_data);
        title('data_autocorrelation');
        auto_corr_add=[fig_add,'_acf.fig'];
        saveas(figure(2),auto_corr_add);
        close(figure(2));
        %xlim([20 20000]);
        else
            figure_observe(auto_corr_data,'data_autocorrelation');
        end
    case 2        
        [Xor,~]=xcorr(abs(data),'unbiased');
        if control_m==1
        figure(3);
        plot(Xor);
        title('data_xcorr');
%         xlim([length(Xor)/2-10000 length(Xor)/2+10000]);
        x_corr_add=[fig_add,'_xcorr.fig'];
        saveas(figure(3),x_corr_add);
        close(figure(3));
        else
           figure_observe(Xor,'data_autocorrelation');
        end
    case 3
        if(method==1)
        fft_chaos=2^nextpow2(length(data));
        f_chaos=fft(data,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
        fx = fs/2*linspace(0,1,fft_chaos/2+1);
        r_f_chaos=abs(f_chaos/length(data));
        r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
        r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1);       
        if control_m==1
        figure(4);       
%         plot(fx,r_f_chaos);
%         plot(fx,10*log(r_f_chaos));%0.2334s
        plot(fx,smooth(10*log(r_f_chaos)));%0.5532s        
        title('analysis in frequency-domain');
        xlabel('f/Hz');
        ylabel('P/dBm');
        if nargin==7
            hold on;
            fft_chaos=2^nextpow2(length(base_noise));
            f_chaos=fft(base_noise,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
            fx = fs/2*linspace(0,1,fft_chaos/2+1);
            r_f_chaos=abs(f_chaos/length(base_noise));
            r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
            r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1); 
            plot(fx,smooth(10*log(r_f_chaos)));
            hold off;
            legend('signal','base-noise');
        end
        frequency_add=[fig_add,'_frequency.fig'];
        saveas(figure(4),frequency_add);
        close(figure(4));
        else
           figure_observe_3_1(fx,r_f_chaos,'analysis in frequency-domain','f/Hz');
        end
        else
            if(length(data)>=fs)
            f_chaos=fft(data(1:fs));
            r_f_chaos=2*abs(f_chaos(2:fs/2)/length(data));
            if control_m==1
            figure(4);
%             plot(r_f_chaos);
%             plot(fx,10*log(r_f_chaos));%0.2334s
            plot(smooth(10*log(r_f_chaos)));%0.5532s
            title('analysis in frequency-domain');
            xlabel('f/Hz');
            ylabel('P/dBm');
            if nargin==7
                hold on;
                f_chaos=fft(base_noise(1:fs));
                r_f_chaos=2*abs(f_chaos(2:fs/2)/length(base_noise));
                plot(smooth(10*log(r_f_chaos)));
                hold off;
                legend('signal','base-noise');
            end
            frequency_add=[fig_add,'_frequency(2).fig'];
            saveas(figure(4),frequency_add);
            close(figure(4));
            else
             figure_observe_3_2(r_f_chaos,'analysis in frequency-domain','f/Hz');   
            end
            else
                disp('the data number is less than fs,so the method is not suitable for fft ');
            end
        end
    case 4       
        if(method==1)
        fft_chaos=2^nextpow2(length(data));
        f_chaos=fft(data,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
        fx = fs/2*linspace(0,1,fft_chaos/2+1);
        r_f_chaos=abs(f_chaos/length(data));
        r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
        r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1);
        t=length(data)/fs*1e9*linspace(0,1,length(data));
        if control_m==1
        figure(4);
        subplot(211);
        plot(t,data);
        title('analysis in time-domain');
        xlabel('t/ns');
        subplot(212);        
        plot(fx,r_f_chaos);
        title('analysis in frequency-domain');
        xlabel('f/Hz');
        else
           figure_observe_4_1(t,data,'analysis in time-domain','t/ns',fx,r_f_chaos,'analysis in frequency-domain','f/Hz');
        end
        else
            if(length(data)>=fs)
            f_chaos=fft(data(1:fs));
            r_f_chaos=2*abs(f_chaos(2:fs/2)/length(data));
            t=length(data)/fs*1e9*linspace(0,1,length(data));
            if control_m==1
            figure(4);
            subplot(211);
            plot(t,data);
            title('analysis in time-domain');
            xlabel('t/ns');
            subplot(212);
            plot(r_f_chaos);
            title('analysis in frequency-domain');
            xlabel('f/Hz');
            else
               figure_observe_4_2(t,data,'analysis in time-domain','t/ns',r_f_chaos,'analysis in frequency-domain','f/Hz');   
            end
            else
                disp('the data number is less than fs,so the method is not suitable for fft ');
            end
        end
    case 5
        figure(5)
        suplot(311);        
        t=length(data)/fs*1e9*linspace(0,1,length(data));
        plot(t,data);
        title('analysis in time-domain');
        xlabel('t/ns');
        if(method==1)
        fft_chaos=2^nextpow2(length(data));
        f_chaos=fft(data,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
        fx = fs/2*linspace(0,1,fft_chaos/2+1);
        r_f_chaos=abs(f_chaos/length(data));
        r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
        r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1);
        subplot(312);        
        plot(fx,r_f_chaos);
        title('analysis in frequency-domain');
        xlabel('f/Hz');
        else
            if(length(data)>=fs)
            f_chaos=fft(data(1:fs));
            r_f_chaos=2*abs(f_chaos(2:fs/2)/length(data));                
            subplot(312);
            plot(r_f_chaos);
            title('analysis in frequency-domain');
            xlabel('f/Hz');
            else
                disp('the data number is less than fs,so the method is not suitable for fft ');
            end
        end
        subplot(313);        
        auto_corr_data=autocorr(data);
        plot(auto_corr_data(1:400));
        title('data_autocorrelation');
    otherwise
        disp('input integer n is out of range 1~4');
        return ;
end

    
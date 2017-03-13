function [maxnum,x_maxnum,minnum,x_minnum,midrange]=myplot_analysis(varargin) 
% [maxnum,x_maxnum,minnum,x_minnum,midrange]=myplot_analysis(data,type,fs,method) 
%type=1--仅自相关
%type=2--仅互相关
%type=3--仅时域和频域
%type=4--时域频域和自相关
%range指绘制数据范围
%method=1标准频谱，
%method~=1较为真实信号频谱
%data长度小于fs时不会处理
%data=data(1:1e7);
if nargin<4||nargin>5
    disp('the num of variable Value is error!');
    return;
end
data=varargin{1};
type=varargin{2};
fs=varargin{3};
method=varargin{4};
if nargin==5
    base_noise=varargin{5};
end
midrange=10000;
switch(type)
    case 1
        %figure(2);
        [auto_corr_data,~]=autocorr(data,length(data)-1);
        plot(auto_corr_data);
        mid_am=max(auto_corr_data(1000:floor(length(data)/10)));
        midrange=find(auto_corr_data(1000:floor(length(data)/10))==mid_am)+999;
        maxnum=max(auto_corr_data(midrange-200:midrange+200));
        x_maxnum=find(auto_corr_data(midrange-200:midrange+200)==maxnum)+midrange-201;
        minnum=min(auto_corr_data(midrange-200:midrange+200));
        x_minnum=find(auto_corr_data(midrange-200:midrange+200)==minnum)+midrange-201;
        if maxnum<0.2
            ylim_up=0.3;
        else if maxnum<0.4
                ylim_up=0.5;
            else
                ylim_up=0.8;
            end
        end
        
        if minnum>-0.1
            ylim_down=-0.2;
        else if minnum>-0.3
                ylim_down=-0.4;
            else
                ylim_down=-0.6;
            end
        end
        title('data_autocorrelation');
        text(x_maxnum,ylim_up*0.5,['(',num2str(x_maxnum),',',num2str(maxnum),')'],'FontSize',10);
        text(x_minnum,ylim_down*0.5,['(',num2str(x_minnum),',',num2str(minnum),')'],'FontSize',10);
        xlim([0 2*midrange+500]);
        ylim([ylim_down ylim_up]);
    case 2
        figure(3);
        [Xor,~]=xcorr(abs(data),'unbiased');
        plot(Xor);
        title('data_xcorr');
         xlim([length(Xor)/2-40000 length(Xor)/2+40000]);
    case 3
        %figure(4);
%         subplot(211)
%         t=length(data)/fs*1e9*linspace(0,1,length(data));
%         plot(t,data);
%         title('analysis in time-domain');
%         xlabel('t/ns');
        %xlim([0 1]);
        if(method==1)
        fft_chaos=2^nextpow2(length(data));
        f_chaos=fft(data,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
        fx = fs/2*linspace(0,1,fft_chaos/2+1);
        r_f_chaos=abs(f_chaos/length(data));
        r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
        r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1);
%         subplot(212);        
%         plot(fx,10*log(r_f_chaos));%0.2334s
        plot(fx,smooth(10*log(r_f_chaos)));%0.5532s
        title('analysis in frequency-domain');
        xlabel('f/Hz');
        ylabel('P/dBm');
        if nargin==5
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
%         if length(find(r_f_chaos>max(r_f_chaos)*0.008))<100
%             ylim([0 max(r_f_chaos)*0.008]);
%         else
%             if length(find(r_f_chaos>max(r_f_chaos)*0.05))<20
%                 ylim([0 max(r_f_chaos)*0.05]);
%             else
%                 if length(find(r_f_chaos>max(r_f_chaos)*0.2))<20
%                     ylim([0 max(r_f_chaos)*0.2]);
%                 else
%                     if length(find(r_f_chaos>max(r_f_chaos)*0.5))<20
%                         ylim([0 max(r_f_chaos)*0.5]);
%                     else
%                         if length(find(r_f_chaos>max(r_f_chaos)*0.8))<20
%                             ylim([0 max(r_f_chaos)*0.8]);
%                         else
%                             ylim([0 max(r_f_chaos)*1.1]);
%                         end
%                     end
%                 end
%             end
%         end
        else
            if(length(data)>=fs)
            f_chaos=fft(data(1:fs));
            r_f_chaos=2*abs(f_chaos(2:fs/2)/length(data));                
%             subplot(212);
            plot(r_f_chaos);
            title('analysis in frequency-domain');
            xlabel('f/Hz');
            ylabel('P/dBm');
            if nargin==5
                hold on;
                f_chaos=fft(base_noise(1:fs));
                r_f_chaos=2*abs(f_chaos(2:fs/2)/length(base_noise));   
                plot(smooth(10*log(r_f_chaos)));
                hold off;
                legend('signal','base-noise');
            end
            else
                disp('the data number is less than fs,so the method is not suitable for fft ');
            end
        end
    case 4
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
        ylim([0 5e-5]);%可注释
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

    
function [maxnum,x_maxnum,minnum,x_minnum,midrange]=myplot_analysis_only_acf(data) 
%type=1--仅自相关
%type=2--仅互相关
%type=3--仅时域和频域
%type=4--时域频域和自相关
%range指绘制数据范围
%method=1标准频谱，
%method~=1较为真实信号频谱
%data长度小于fs时不会处理
%data=data(1:1e7);
[auto_corr_data,~]=autocorr(data,length(data)-1);
% plot(auto_corr_data);
mid_am=max(auto_corr_data(1000:floor(length(data)/10)));
midrange=find(auto_corr_data(1000:floor(length(data)/10))==mid_am)+999;
maxnum=max(auto_corr_data(midrange-200:midrange+200));
x_maxnum=find(auto_corr_data(midrange-200:midrange+200)==maxnum)+midrange-201;
minnum=min(auto_corr_data(midrange-200:midrange+200));
x_minnum=find(auto_corr_data(midrange-200:midrange+200)==minnum)+midrange-201;


function [maxnum,x_maxnum,minnum,x_minnum,midrange]=myplot_analysis_only_acf(data) 
%type=1--�������
%type=2--�������
%type=3--��ʱ���Ƶ��
%type=4--ʱ��Ƶ��������
%rangeָ�������ݷ�Χ
%method=1��׼Ƶ�ף�
%method~=1��Ϊ��ʵ�ź�Ƶ��
%data����С��fsʱ���ᴦ��
%data=data(1:1e7);
[auto_corr_data,~]=autocorr(data,length(data)-1);
% plot(auto_corr_data);
mid_am=max(auto_corr_data(1000:floor(length(data)/10)));
midrange=find(auto_corr_data(1000:floor(length(data)/10))==mid_am)+999;
maxnum=max(auto_corr_data(midrange-200:midrange+200));
x_maxnum=find(auto_corr_data(midrange-200:midrange+200)==maxnum)+midrange-201;
minnum=min(auto_corr_data(midrange-200:midrange+200));
x_minnum=find(auto_corr_data(midrange-200:midrange+200)==minnum)+midrange-201;


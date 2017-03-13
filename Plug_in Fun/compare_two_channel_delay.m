function [label_osc_connect,lagDiff,coeff]=compare_two_channel_delay(obj,precision_type,channel1,channel2)
%%用于计算两个通道信号的相关延时
% corrcoef
%xcorr
label_osc_connect=1;
lagDiff=0;
coeff=0;
channel_str1=['channel',num2str(channel1)];
channel_str2=['channel',num2str(channel2)];
try
  connect(obj);
  state_channel1=get(obj.Channel(channel1),'State');
  state_channel2=get(obj.Channel(channel2),'State');
  set(obj.Channel(channel1),'State','on');
  set(obj.Channel(channel2),'State','on');
  groupObj = get(obj, 'Waveform');
  groupObj = groupObj(1);
  if precision_type==1
    [data1,~]=precision_int16(groupObj, channel_str1,true);
    pause(1);
    [data2,~]=precision_int16(groupObj, channel_str2,true);
  else
    [data1,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str1); 
    pause(1);
    [data2,~,~,~,~] = invoke(groupObj, 'readwaveform', channel_str2); 
  end
  disp('data got');
  set(obj.Channel(channel1),'State',state_channel1);
  set(obj.Channel(channel2),'State',state_channel2);
  disconnect(obj);
catch
  label_osc_connect=0;
  disp('network is disabled!!');  
  return;
end
length_data=min(length(data1),length(data2));
coeff=corrcoef(data1(1:length_data),data2(1:length_data));
[acor,lag] = xcorr(data1,data2);
[~,I] = max(abs(acor));
lagDiff= lag(I);

% figure
% plot(lag,acor)
% a3 = gca;
% a3.XTick = sort([-3000:1000:3000 lagDiff]);


function SA_spectrum_save(SA_obj,path_head_SA,SA_file_name,SA_title_name,type)
%--type=1-file,2-fig,3-file and fig
%%----get the spectrum wave
Start_frequency=str2double(query(SA_obj, 'FA?'));
Stop_frequency=str2double(query(SA_obj, 'FB?'));
SA_file_name=[SA_file_name,'_',num2str(Start_frequency,'%.3e'),'to',num2str(Stop_frequency,'%.3e')];
SA_title_name=[SA_title_name,'\_',num2str(Start_frequency,'%.3e'),'to',num2str(Stop_frequency,'%.3e')];
if exist(fullfile(path_head_SA,[SA_file_name,'.dat']),'file')
    disp('ÎÄ¼þÃüÃû´íÎó');
    return;
end
% winopen(path_head_SA);
% clipboard('copy',fullfile(path_head_SA,[SA_file_name,'.dat']));
fprintf(SA_obj,'DL0');
fprintf(SA_obj,'DET NEG');
fprintf(SA_obj,'TAA?');
% fre_data=sscanf(query(SA_obj,'TAA?'),'%f');
data_length=1001;%--------------------------------------------------------
fre_data=zeros(1,data_length);
for i=1:data_length
 fre_data(i) = fscanf(SA_obj,'%f'); 
end
pause(0.1);
Reference_level=str2double(query(SA_obj, 'RL?'));
DB_div=str2double(query(SA_obj, 'DD?'));%0-10dB,1-5dB,2-2dB,3-1dB
DB_div_value_list=[10,5,2,1];
DB_div_value=DB_div_value_list(DB_div+1); 
real_data_x=(0:1:1000)*(Stop_frequency-Start_frequency)/1000+Start_frequency;
real_data_y=Reference_level-10*DB_div_value*(14592-fre_data)/(14592-1792);
%%----save file
if type~=2
dlmwrite(fullfile(path_head_SA,[SA_file_name,'.csv']),[real_data_x;real_data_y],'precision',9);
end
%%----save fig
if type~=1
figure(1);
plot(real_data_x,real_data_y);
xlabel('Frequency/nm');
ylabel('Power/dBm');
title(SA_title_name);
saveas(gcf,fullfile(path_head_SA,[SA_file_name,'.fig']));
end

% temp=zeros(1,10000);
% for i=1:10000
%      back_data=get(SA_obj,'BytesAvailable');
%      %back_data=obj_sa.BytesAvailable;
%      if back_data>=1
%          temp(i)=back_data;
%           DataReceived(i) = fscanf(SA_obj,'%f'); 
%      else
%           length_data=i-1;
%           break;
%      end
% end
% fre_data=DataReceived(1:length_data);

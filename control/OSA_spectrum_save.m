function bandwidth_3dB=OSA_spectrum_save(OSA_obj,path_head_OSA,OSA_file_name,OSA_title_name,type)
%%-----------------------------
%--type=1-file,2-fig,3-file and fig
fprintf(OSA_obj, 'SPSWP1');
fscanf(OSA_obj);%用于清空缓存SP_SINGLE_SWEEP
wave_data_x=sscanf(query(OSA_obj,'SPDATAWL0'),'%f');%0为trace
pause(0.4);
wave_data_y=sscanf(query(OSA_obj,'SPDATAD0'),'%f');
wave_data=zeros(2,length(wave_data_x)-1);
wave_data(1,:)=wave_data_x(2:end);
wave_data(2,:)=wave_data_y(2:end);
% bandwidth_label=questdlg('是否计算3dB带宽？','操作','Yes','No','Yes');
bandwidth_label='Yes';%----------------------------------------
bandwidth_3dB=0;
if strcmp(bandwidth_label,'Yes')
    bandwidth_3dB=get_3db_bandwidth(wave_data(1,:),wave_data(2,:));
end
OSA_file_name=[OSA_file_name,'_',num2str(bandwidth_3dB)];
OSA_title_name=[OSA_title_name,'\_',num2str(bandwidth_3dB)];
%%---save data
%%--------save file
if type~=2
   dlmwrite(fullfile(path_head_OSA,[OSA_file_name,'.csv']),wave_data);
end
%%--------save fig
if type~=1
figure(1);
plot(wave_data(1,:),wave_data(2,:));
xlabel('Wavelength/nm');
ylabel('Power/dBm');
title(OSA_title_name);
saveas(gcf,fullfile(path_head_OSA,[OSA_file_name,'.fig']));
end
% close(gcf);
% pause;
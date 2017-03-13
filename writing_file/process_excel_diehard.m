function process_excel_diehard(filespec,data_ds,data_ico,type)
% clc
% clear
% addpath(genpath('.\writing_file'));
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\excel_file_01';
% [length_ico,length_ds]=integration_excel_ico_single(filespec);
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\bin_data_01diehard\diehard_excel';
% [length_ico,length_ds]=integration_excel_ico_single(filespec);
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\bin_data_01_resultlog\result_excel';
[excel_data,~,~]=xlsread([filespec,'\log_result.xlsx'],1);%analyse,diehard_result
% data_ds=0:100:2100;
% data_ico=-98:2:98;
ds_x=zeros(length(data_ds),length(data_ico));
ico_y=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    ds_x(i,1:end)=data_ds(i);
    ico_y(i,1:end)=data_ico;
end


data_ico_diehard=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ico)
    data_ico_diehard(1:end,i)=excel_data((i-1)*length(data_ds)+1:i*length(data_ds),20);
end

figure(1);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_diehard.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_diehard.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('pass_num');
colormap(jet);
colorbar;
title('Diehard');
saveas(gcf,fullfile(filespec,file_name));
close(gcf);
function add_analyse(origin_address)
% origin_address='G:\Experiment_auto\diehard_file\2017-02-28 05-54\bin_data_01';
add_file_dir=[origin_address,'_add_analyse'];
if ~exist(add_file_dir,'dir')
    mkdir(add_file_dir);
end
dir_address_ico=get_all_dir(origin_address);
length_ico=length(dir_address_ico);
ico_value=zeros(1,length_ico);
ico_position=strfind(dir_address_ico,'ICO-');
dir_address_ds=cell(1,length_ico);
for loop_ico=1:length_ico
    dir_address_ds{1,loop_ico}=get_all_dir(dir_address_ico{1,loop_ico});
    ico_value(loop_ico)=str2double(dir_address_ico{1,loop_ico}(ico_position{1,loop_ico}+4:end));
end
length_ds=length(dir_address_ds{1,1});
ds_value=zeros(1,length_ds);
ds_position=strfind(dir_address_ds{1,1},'DS-');
for loop_ds=1:length_ds
   ds_value(loop_ds)=str2double(dir_address_ds{1,1}{1,loop_ds}(ds_position{1,loop_ds}+3:end)); 
end
analyse_data=zeros(length_ico*length_ds,8);
for loop_ico=1:length_ico
    for loop_ds=1:length_ds
        data=dlmread(fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_0001.dat'));
        max_value=max(data);
        min_value=min(data);
        block_value=max_value-min_value;
        skewness_value=skewness(data);
        kurtosis_value=kurtosis(data);
        mode_value=mode(data);
        analyse_data((loop_ds-1)*length_ico+loop_ico,:)=[ds_value(loop_ds),ico_value(loop_ico),max_value,min_value,block_value,skewness_value,kurtosis_value,mode_value];
    end
end
excel_file_address=fullfile(add_file_dir,'add_analyse.xlsx');
xlswrite(excel_file_address,{'Dispersion','ICO','Max_value','Min_value','Block_value','Skewness','Kurtosis','Mode_value'},'sheet1','A1:H1');
xlswrite(excel_file_address,analyse_data,'sheet1',['A2:H:',num2str(length_ico*length_ds+1)]);
% ds_value=0:100:2100;
% ico_value=-98:2:98;
ds_x=zeros(length(ds_value),length(ico_value));
ico_y=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    ds_x(i,1:end)=ds_value(i);
    ico_y(i,1:end)=ico_value;
end

% add_file_dir='C:\Users\huye\Desktop\mm';
type=2;
data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),1);
end

figure(1);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Max_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Max_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Max');
colormap(jet);
colorbar;
title('Max\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);

data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),2);
end

figure(2);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Min_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Min_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Min');
colormap(jet);
colorbar;
title('Min\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);

data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),3);
end

figure(3);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Block_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Block_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Block');
colormap(jet);
colorbar;
title('Block\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);

data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),4);
end

figure(4);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Skewness_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Skewness_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Skewness');
colormap(jet);
colorbar;
title('Skewness\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);

data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),5);
end

figure(5);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Kurtosis_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Kurtosis_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Kurtosis');
colormap(jet);
colorbar;
title('Kurtosis\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);

data_ico_diehard=zeros(length(ds_value),length(ico_value));
for i=1:length(ds_value)
    data_ico_diehard(i,1:end)=analyse_data((i-1)*length(ico_value)+1:i*length(ico_value),6);
end

figure(6);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Mode_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Mode_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Mode');
colormap(jet);
colorbar;
title('Mode\_single');
saveas(gcf,fullfile(add_file_dir,file_name));
close(gcf);


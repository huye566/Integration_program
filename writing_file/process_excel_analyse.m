function process_excel_analyse(filespec,data_ds,data_ico,type)
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\excel_file_01';
% [length_ico,length_ds]=integration_excel_ico_single(filespec);
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\bin_data_01diehard\diehard_excel';
% [length_ico,length_ds]=integration_excel_ico_single(filespec);
% filespec='G:\Experiment_auto\diehard_file\2017-02-28 05-54\excel_file_01';
[excel_data,~,~]=xlsread([filespec,'\analyse.xlsx'],1);%analyse,diehard_result
% data_ds=0:100:2100;
% data_ico=-98:2:98;
ds_x=zeros(length(data_ds),length(data_ico));
ico_y=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    ds_x(i,1:end)=data_ds(i);
    ico_y(i,1:end)=data_ico;
end


data_ico_diehard=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    data_ico_diehard(i,1:end)=excel_data((i-1)*length(data_ico)+1:i*length(data_ico),9);
end

figure(1);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Symmetry_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Symmetry_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Symmetry');
colormap(jet);
colorbar;
title('Symmetry\_single');
saveas(gcf,fullfile(filespec,file_name));
close(gcf);

data_ico_diehard=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    data_ico_diehard(i,1:end)=excel_data((i-1)*length(data_ico)+1:i*length(data_ico),11);
end

figure(2);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_Symmetry_average.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_Symmetry_average.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('Symmetry(av)');
colormap(jet);
colorbar;
title('Symmetry\_average');
saveas(gcf,fullfile(filespec,file_name));
close(gcf);

data_ico_diehard=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    data_ico_diehard(i,1:end)=excel_data((i-1)*length(data_ico)+1:i*length(data_ico),10);
end

figure(3);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_ACF_single.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_ACF_single.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('ACF');
colormap(jet);
colorbar;
title('ACF\_single');
saveas(gcf,fullfile(filespec,file_name));
close(gcf);

data_ico_diehard=zeros(length(data_ds),length(data_ico));
for i=1:length(data_ds)
    data_ico_diehard(i,1:end)=excel_data((i-1)*length(data_ico)+1:i*length(data_ico),12);
end

figure(4);
%set(gcf,'Visible','off');
if type==1
    surf(ds_x,ico_y,data_ico_diehard,'LineStyle','none');
    file_name='a_ACF_average.fig';
else
    contourf(ds_x,ico_y,data_ico_diehard);
    file_name='c_ACF_average.fig';
end
xlabel('DS/ps/km');ylabel('ICO/Ghz');zlabel('ACF(av)');
colormap(jet);
colorbar;
title('ACF\_average');
saveas(gcf,fullfile(filespec,file_name));
close(gcf);
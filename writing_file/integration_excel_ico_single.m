function [data_ico,data_ds]=integration_excel_ico_single(origin_dir)
[~,~,figure_head]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');
file_integration=[origin_dir,'\','analyse.xlsx'];
if exist(file_integration,'file')
    delete(file_integration);
end      
dirOutput=dir(fullfile(origin_dir,'*.xlsx'));
fileNames={dirOutput.name}';%cell(n,1)
file_num=length(fileNames);    
% write_excel_single(filespec_excel,figure_head,'A1:M1');%wps必须
xlswrite(file_integration,figure_head,'sheet1','A1:M1');%最后两个是sym(average),acf(average);
[excel_data,~,~]=xlsread([origin_dir,'\',fileNames{1}],1);
length_ico=file_num;
data_ds=excel_data(1:end,1);
length_ds=length(data_ds);
excel_data=zeros(length_ico*length_ds,length(excel_data(1,1:end)),3);
for file_i=1:file_num
    address_file=[origin_dir,'\',fileNames{file_i}];
    [excel_data(file_i:length_ico:end,1:end,1),~,~]=xlsread(address_file,1); 
end
data_ico=excel_data(1:length_ico,2,1);
xlswrite(file_integration,excel_data(:,:,1),'sheet1',['B2:M',num2str(length_ico*length_ds+1)]);%最后两个是sym(average),acf(average);
% write_excel(file_integration,excel_data);

function [length_ico,length_ds]=integration_excel_ico(origin_dir)
 dirOutput=dir(fullfile(origin_dir,'*.xlsx'));
 fileNames={dirOutput.name}';%cell(n,1)
 file_num=length(fileNames);
 file_integration=[origin_dir,'\','analyse.xlsx'];
 [excel_data,~,~]=xlsread([origin_dir,'\',fileNames{1}],1);
 length_ico=file_num;
 length_ds=length(excel_data(1:end,1));
 excel_data=zeros(length_ico*length_ds,length(excel_data(1,1:end)),3);
 for file_i=1:file_num
     address_file=[origin_dir,'\',fileNames{file_i}];
     [excel_data(file_i:length_ico:end,1:end,1),~,~]=xlsread(address_file,1);
     [excel_data(file_i:length_ico:end,1:end,2),~,~]=xlsread(address_file,2); 
     [excel_data(file_i:length_ico:end,1:end,3),~,~]=xlsread(address_file,3); 
 end
 write_excel(file_integration,excel_data);
end
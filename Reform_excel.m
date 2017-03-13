clc
clear
%%转换excel程序
origin_dir='C:\Users\huye\Desktop\diehard_excel';
[~,~,figure_head]=xlsread('.\doc_serial\figure_status_head_auto.xlsx');  
 dirOutput=dir(fullfile(origin_dir,'*.xlsx'));
 fileNames={dirOutput.name}';%cell(n,1)
 file_num=length(fileNames);
 for file_i=1:file_num
     address_file=[origin_dir,'\',fileNames{file_i}];
     [temp,~,~]=xlsread(address_file,1); 
     temp_2=zeros(length(temp(:,1)),length(temp(1,:))+1);
     temp_2(:,end)=roundn(temp(:,end)/11,-5);%/11
     temp_2(:,1:end-2)=temp(:,1:end-1);
     temp_3=cell(length(temp(:,1)),1);
     % write_excel_single(filespec_excel,figure_head,'A1:M1');%wps必须
     xlswrite(address_file,figure_head,'sheet1','A1:M1');%最后两个是sym(average),acf(average);
     xlswrite(address_file,temp_3,'sheet1',['A2:A',num2str(length(temp(:,1))+1)]);%最后两个是sym(average),acf(average);
     xlswrite(address_file,temp_2,'sheet1',['B2:M',num2str(length(temp(:,1))+1)]);%最后两个是sym(average),acf(average);
 end
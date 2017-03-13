function file_address=get_all_file(start_dir,filename)
%file_address=get_all_file('C:\Users\li\Desktop\huye\test1','*.bin');%ÎªcellÊä³ö
dirOutput=dir(fullfile(start_dir,filename));
fileNames={dirOutput.name}';%cell(n,1)
file_num=length(fileNames);
file_address=cell(1,file_num);
for file_i=1:file_num
    file_address{1,file_i}=[start_dir,'\',fileNames{file_i}];
end
end

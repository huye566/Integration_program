function dir_address=get_all_dir(start_dir)
%%%dir_address=get_all_dir('C:\Users\li\Desktop\huye');%为cell输出
dir_info = dir(start_dir);
isub = [dir_info(:).isdir]; %# returns logical vector
nameFolds = {dir_info(isub).name}';
nameFolds(ismember(nameFolds,{'.','..'})) = [];%可以把'.','..'从数组中剔除。cell(n,1)
dir_num=length(nameFolds);
dir_address=cell(1,dir_num);
for dir_i=1:dir_num
    dir_address{1,dir_i}=fullfile([start_dir,'\',nameFolds{dir_i}]);
end
end
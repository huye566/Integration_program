function generate_test_bin(ico_num,dir_address_ds,diehard_dir_address_ds,diehard_excel)
data_excel=cell(1,length(ico_num));
for loop_ico=1:length(ico_num)  
    data_excel_temp=zeros(length(dir_address_ds{1,loop_ico}),10);%³ýÈ¥ok.bin
    for loop_ds=1:length(dir_address_ds{1,loop_ico})        
        temp_bin_add=get_all_file(dir_address_ds{1,loop_ico}{1,loop_ds},'*.bin');
        for loop_file=1:length(temp_bin_add)
            fid_bin= fopen(temp_bin_add{1,loop_file},'rb');
            data=fread(fid_bin);
            fclose(fid_bin);
            if loop_file==1
                dist_add_txtname=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_distribution.txt');
                dist_add_figname1=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_dis1.fig');
                dist_add_figname2=fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_xor_dis2.fig');
                if length(data)<8e6
                    [~,~,~]=distribution_analysis_batch(data,2,dist_add_txtname,dist_add_figname1,dist_add_figname2);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis_only_acf(data);  
                else
                    [~,~,~]=distribution_analysis_batch(data(1:8e6),2,dist_add_txtname,dist_add_figname1,dist_add_figname2);
                    [maxnum,x_maxnum,minnum,x_minnum,~]=myplot_analysis_only_acf(data(1:8e6));  
                end                
                diehard_binary_improvement(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},data,2,0);
            else
                diehard_binary_improvement(diehard_dir_address_ds{1,loop_ico}{1,loop_ds},data,2,1);
            end
        end
        data_excel_temp(loop_ds,1:end)=[diehard_dir_address_ds{1,loop_ico}{2,loop_ds},ico_num(loop_ico),maxnum,...
                x_maxnum,minnum,x_minnum,0,0,0,max(abs(maxnum),abs(minnum))];      
    end
    data_excel{1,loop_ico}=data_excel_temp;
end
for i=start_position:num_dir
        xlswrite(diehard_excel{1,i},data_excel{1,i});
    %     write_excel(diehard_excel{i},data_excel{1,i});
end
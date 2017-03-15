function add_frequency_smooth(origin_address)
% origin_address='G:\Experiment_auto\diehard_file\2017-02-28 05-54\bin_data_01';
add_file_dir=[origin_address,'_add_frequency_smooth'];
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
for loop_ico=1:length_ico
    for loop_ds=1:length_ds
        temp_file_name=['Frequency_',get_ordered_str_3((loop_ico-1)*length_ds+loop_ds),'_ICO(',...
            num2str(loop_ico),')_DS(',num2str(loop_ds),').fig'];
        temp_file_address=fullfile(add_file_dir,temp_file_name);
        data=dlmread(fullfile(dir_address_ds{1,loop_ico}{1,loop_ds},'huye_0001.dat'));
        fft_chaos=2^nextpow2(length(data));
        f_chaos=fft(data,fft_chaos);%若未进行fft_chaos处理会产生频率偏移，尤其当m的值较大的时候。
        r_f_chaos=abs(f_chaos/length(data));
        r_f_chaos=r_f_chaos(1:fft_chaos/2+1);
        r_f_chaos(2:end-1)=2*r_f_chaos(2:end-1);
%         [up,~]=envelope(smooth(10*log(r_f_chaos)),4000,'peak');
%         plot(fs/2*linspace(0,1,length(up(1:1000:end))),up(1:1000:end));
%         subplot(212);        
%         plot(fx,10*log(r_f_chaos));%0.2334s
        temp_f=reshape(10*log(r_f_chaos(1:floor(length(r_f_chaos)/1000)*1000)),1000,floor(length(r_f_chaos)/1000));
        final_f=max(temp_f);
        h=figure((loop_ico-1)*length_ds+loop_ds);
        plot(fs/2*linspace(0,1,length(final_f)),smooth(final_f));
        title(['Frequency\_',get_ordered_str_3((loop_ico-1)*length_ds+loop_ds),'\_ICO(',...
            num2str(loop_ico),')\_DS(',num2str(loop_ds),')']);
        xlabel('f/Hz');
        ylabel('P/dBm');
        saveas(h,temp_file_address);
        close(h);
    end
end

function num_str=get_ordered_str_3(num)
if num<10
        num_str=['00',num2str(num)];
else
    if num<100
        num_str=['0',num2str(num)];
    else
        num_str=num2str(num);
    end
end

% ds_value=0:100:2100;
% ico_value=-98:2:98;


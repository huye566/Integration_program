% 二进制到十进制：bin2dec(H), 例如 y=bin2dec('100111')
% 十进制到二进制：dec2bin(H)
% 类似，十六进制：hex2dec(H) , dec2hex(H)
% 任意进制：base2dec(S,B),其中，S是数据，B是进制基数。B为2~36之间的整数，S为整形
% 如八进制转化为十进制：base2dec('11',8)的结果是9 
%method=1-----无损失数据处理，生成二进制流数据
%method=2-----%同ASC2BIN.EXE工具处理，生成二进制流数据
%method=3-----生成ASC2BIN.EXE需要文件
%method_type=1,不需要大存储，但需要多次写入（76.97s），method_type=2,需要大存储，但仅一次写入（77.732s）相差不大，
%所以使用method_type=1
% if(method==2||method==1)
%     system('D:\code\matlab\dataprocessing\diehard_tool\DIEHARD.EXE');
% end
% if(method==3)
%     system('D:\code\matlab\dataprocessing\diehard_tool\ASC2BIN.EXE');
% end
%经过分析
function diehard_binary(address_diehard_doc,data,method,method_type)
%diehard_binary('.\diehard\diehard_tool\huye.bin',data,2,1);
progress_bar=waitbar(0,'二进制文件写入进度');
switch(method)
    case 1
        %结果与使用diehard
        %ASC2BIN.EXE工具会每隔1024行多一行，因为该程序每次处理410*80=32800数据转换成1024*32=32768，剩下的数据舍弃（差正好为32，即一行的数据）
        %而且数据量不够410*80=32800的尾部数据全部舍去；
%         address_diehard_doc='.\diehard_tool\huye.bin';
        fid_diehard_doc=fopen(address_diehard_doc,'wb');
        %无损失数据处理
        num_loop=floor(length(data)/128)*4; 
        if(method_type==1)
        for i=1:num_loop
           temp_change=binary32change(data((i-1)*32+1:i*32));
           temp_change_dec=zeros(1,4);
           for j=1:4
           temp_change_dec(j)=bin2dec(num2str(temp_change((j-1)*8+1:j*8)));
           end
           fwrite(fid_diehard_doc,temp_change_dec,'uint8');
%            if(mod(i,floor(num_loop/100))==0)
%                sprintf('处理进度：%d%%',floor(i/num_loop*100))
%            end
            waitbar(i/num_loop,progress_bar)
        end
        else
        temp_change_dec=zeros(1,4*num_loop);
        for i=1:num_loop
           temp_change=binary32change(data((i-1)*32+1:i*32));           
           for j=1:4
           temp_change_dec((i-1)*4+j)=bin2dec(num2str(temp_change((j-1)*8+1:j*8)));
           end           
%            if(mod(i,floor(num_loop/100))==0)
%                sprintf('处理进度：%d%%',floor(i/num_loop*100))
%            end
          waitbar(i/num_loop,progress_bar)
        end 
        fwrite(fid_diehard_doc,temp_change_dec,'uint8');
        end
         fclose(fid_diehard_doc);
         disp('处理进度：all is ok');
         disp('文件地址如下：');
        disp(address_diehard_doc);
%         system('D:\code\matlab\dataprocessing\diehard_tool\DIEHARD.EXE');
    case 2
        %同ASC2BIN.EXE工具处理
%         address_diehard_doc='.\diehard_tool\huye.bin';
        fid_diehard_doc=fopen(address_diehard_doc,'wb');
        num_loop=floor(length(data)/128)*4;
        num__loop_effective=floor(num_loop/4100)*4100;
        i=1;
        if(method_type==1)
        while (i<=num__loop_effective) 
           temp_change=binary32change(data((i-1)*32+1:i*32)); 
           temp_change_dec=zeros(1,4);
           for j=1:4
           temp_change_dec(j)=bin2dec(num2str(temp_change((j-1)*8+1:j*8)));
           end
           fwrite(fid_diehard_doc,temp_change_dec,'uint8');
%            if(mod(i,floor(num__loop_effective/100))==0)
%                sprintf('处理进度：%d%%',floor(i/num__loop_effective*100))
%            end
           waitbar(i/num__loop_effective,progress_bar)
           if(mod(i+4,4100)==0)
               i=i+4;
           end
           i=i+1;
        end
        else
        temp_change_dec=zeros(1,4*(num__loop_effective-num__loop_effective/4100));
        label_space=0;
        while (i<=num__loop_effective) 
           temp_change=binary32change(data((i-1)*32+1:i*32)); 
           for j=1:4
           temp_change_dec((i-1)*4-label_space*4+j)=bin2dec(num2str(temp_change((j-1)*8+1:j*8)));
           end    
%            if(mod(i,floor(num__loop_effective/100))==0)
%                sprintf('处理进度：%d%%',floor(i/num__loop_effective*100))
%            end
           waitbar(i/num__loop_effective,progress_bar)
           if(mod(i+4,4100)==0)
               i=i+4;
               label_space=label_space+1;
           end
           i=i+1;
        end
        fwrite(fid_diehard_doc,temp_change_dec,'uint8');  
        end 
        fclose(fid_diehard_doc);
        disp('处理进度：all is ok');
        disp('文件地址如下：');
        disp(address_diehard_doc);
%         system('.\diehard_tool\DIEHARD.EXE');
    case 3
%         address_diehard_doc='.\diehard_tool\huye.txt';
        fid_diehard_doc=fopen(address_diehard_doc,'w');
        num_effective=floor(length(data)/320)*320;
        num_effective_loop=num_effective/4;
        for i=1:num_effective_loop-1
            fprintf(fid_diehard_doc,lower(dec2hex(bin2dec(num2str(data((i-1)*4+1:i*4))))));
           if(mod(i,80)==0)
               fprintf(fid_diehard_doc,'\r\n');
           end
%            if(mod(i,floor(num_effective_loop/100))==0)
%                sprintf('处理进度：%d%%',floor(i/num_effective_loop*100))
%            end
           waitbar(i/(num_effective_loop-1),progress_bar)
        end
        fprintf(fid_diehard_doc,lower(dec2hex(bin2dec(num2str(data((num_effective_loop-1)*4+1:num_effective_loop*4))))));
        fclose(fid_diehard_doc);
        disp('处理进度：all is ok');
        disp('ASSCI文件地址如下：');
        disp(address_diehard_doc);
        %system('.\diehard_tool\ASC2BIN.EXE');   
    otherwise
        disp('the integer number of method is out of range 1~2');
        return;
end
close(progress_bar)
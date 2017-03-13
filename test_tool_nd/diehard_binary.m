% �����Ƶ�ʮ���ƣ�bin2dec(H), ���� y=bin2dec('100111')
% ʮ���Ƶ������ƣ�dec2bin(H)
% ���ƣ�ʮ�����ƣ�hex2dec(H) , dec2hex(H)
% ������ƣ�base2dec(S,B),���У�S�����ݣ�B�ǽ��ƻ�����BΪ2~36֮���������SΪ����
% ��˽���ת��Ϊʮ���ƣ�base2dec('11',8)�Ľ����9 
%method=1-----����ʧ���ݴ������ɶ�����������
%method=2-----%ͬASC2BIN.EXE���ߴ������ɶ�����������
%method=3-----����ASC2BIN.EXE��Ҫ�ļ�
%method_type=1,����Ҫ��洢������Ҫ���д�루76.97s����method_type=2,��Ҫ��洢������һ��д�루77.732s������
%����ʹ��method_type=1
% if(method==2||method==1)
%     system('D:\code\matlab\dataprocessing\diehard_tool\DIEHARD.EXE');
% end
% if(method==3)
%     system('D:\code\matlab\dataprocessing\diehard_tool\ASC2BIN.EXE');
% end
%��������
function diehard_binary(address_diehard_doc,data,method,method_type)
%diehard_binary('.\diehard\diehard_tool\huye.bin',data,2,1);
progress_bar=waitbar(0,'�������ļ�д�����');
switch(method)
    case 1
        %�����ʹ��diehard
        %ASC2BIN.EXE���߻�ÿ��1024�ж�һ�У���Ϊ�ó���ÿ�δ���410*80=32800����ת����1024*32=32768��ʣ�µ�����������������Ϊ32����һ�е����ݣ�
        %��������������410*80=32800��β������ȫ����ȥ��
%         address_diehard_doc='.\diehard_tool\huye.bin';
        fid_diehard_doc=fopen(address_diehard_doc,'wb');
        %����ʧ���ݴ���
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
%                sprintf('������ȣ�%d%%',floor(i/num_loop*100))
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
%                sprintf('������ȣ�%d%%',floor(i/num_loop*100))
%            end
          waitbar(i/num_loop,progress_bar)
        end 
        fwrite(fid_diehard_doc,temp_change_dec,'uint8');
        end
         fclose(fid_diehard_doc);
         disp('������ȣ�all is ok');
         disp('�ļ���ַ���£�');
        disp(address_diehard_doc);
%         system('D:\code\matlab\dataprocessing\diehard_tool\DIEHARD.EXE');
    case 2
        %ͬASC2BIN.EXE���ߴ���
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
%                sprintf('������ȣ�%d%%',floor(i/num__loop_effective*100))
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
%                sprintf('������ȣ�%d%%',floor(i/num__loop_effective*100))
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
        disp('������ȣ�all is ok');
        disp('�ļ���ַ���£�');
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
%                sprintf('������ȣ�%d%%',floor(i/num_effective_loop*100))
%            end
           waitbar(i/(num_effective_loop-1),progress_bar)
        end
        fprintf(fid_diehard_doc,lower(dec2hex(bin2dec(num2str(data((num_effective_loop-1)*4+1:num_effective_loop*4))))));
        fclose(fid_diehard_doc);
        disp('������ȣ�all is ok');
        disp('ASSCI�ļ���ַ���£�');
        disp(address_diehard_doc);
        %system('.\diehard_tool\ASC2BIN.EXE');   
    otherwise
        disp('the integer number of method is out of range 1~2');
        return;
end
close(progress_bar)
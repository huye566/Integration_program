%���������������δ���
function diehard_binary_improvement(address_diehard_doc,data,method,write_type)
%diehard_binary_improvement('E:\matlab\dataprocessing\auto_test_corr\diehard\huye2.bin',data,2,0);
%data ������zeros(1,num)
%method=1-----����ʧ���ݴ������ɶ�����������
%method=2-----%ͬASC2BIN.EXE���ߴ������ɶ�����������
%method=3-----��������洢����
%write_type:0--����1-append
%8e6��Ҫ70seconds,method3��0.3seconds
if write_type==0
    fid_diehard_doc=fopen(address_diehard_doc,'wb');
else
    fid_diehard_doc=fopen(address_diehard_doc,'ab');
end
num_loop=floor(length(data)/128)*4;
num__loop_effective=floor(num_loop/4100)*4100;
tic
if method==3
    fwrite(fid_diehard_doc,data,'uint8'); %8λһ�ֽڣ�����0��д��00,1��д��01  
else
    if method==1
        data_reshape=reshape(data(1:num_loop*32),8,[])';   
    else
        data_reshape=reshape(data(1:num__loop_effective*32),8,[])';
    end
data_reshape=bin2dec(num2str(data_reshape));%99%consuming
data_reshape=reshape(data_reshape',4,[]);
data_reshape([1,4],:)=data_reshape([4,1],:);
data_reshape([2,3],:)=data_reshape([3,2],:);
data_reshape=reshape(data_reshape,1,[]);%���п�ʼ����ѭ����
if method==1
    fwrite(fid_diehard_doc,data_reshape,'uint8');   
else
data_final=zeros(1,num__loop_effective*4-num__loop_effective/4100*16);
for i=1:floor(num_loop/4100)
data_final((i-1)*4096*4+1:i*4096*4)=data_reshape((i-1)*4100*4+1:i*4100*4-16);
end
    fwrite(fid_diehard_doc,data_final,'uint8');  
end
end
 fclose(fid_diehard_doc);
 disp('������ȣ�all is ok');
end
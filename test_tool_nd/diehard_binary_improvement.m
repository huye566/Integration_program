%将二进制数据整形处理
function diehard_binary_improvement(address_diehard_doc,data,method,write_type)
%diehard_binary_improvement('E:\matlab\dataprocessing\auto_test_corr\diehard\huye2.bin',data,2,0);
%data 行向量zeros(1,num)
%method=1-----无损失数据处理，生成二进制流数据
%method=2-----%同ASC2BIN.EXE工具处理，生成二进制流数据
%method=3-----不作处理存储数据
%write_type:0--覆盖1-append
%8e6需要70seconds,method3仅0.3seconds
if write_type==0
    fid_diehard_doc=fopen(address_diehard_doc,'wb');
else
    fid_diehard_doc=fopen(address_diehard_doc,'ab');
end
num_loop=floor(length(data)/128)*4;
num__loop_effective=floor(num_loop/4100)*4100;
tic
if method==3
    fwrite(fid_diehard_doc,data,'uint8'); %8位一字节，所以0会写成00,1会写成01  
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
data_reshape=reshape(data_reshape,1,[]);%从列开始读，循环列
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
 disp('处理进度：all is ok');
end
function generation_test_file(file_head,data1,data2,judgment_threshold,method,write_type,selection)
%generation_test_file(file_head,data1,data2,'mean',3,1,1)
%%%type==2,生成diehard and nist file
%method=1-----无损失数据处理，生成二进制流数据
%method=2-----%同ASC2BIN.EXE工具处理，生成二进制流数据
%method=3-----不作处理存储数据
%write_type:0--覆盖1-append
%selection:1-bin,2-txt,3-all
data1=wavedata_2_binary(data1,judgment_threshold);
data2=wavedata_2_binary(data2,judgment_threshold);
data=xor(data1,data2);
switch(selection)
    case 1
        diehard_add_txtname=[file_head,'.bin'];
        diehard_binary_improvement(diehard_add_txtname,data,method,write_type);
    case 2
        nist_add_txtname=[file_head,'.txt'];
        write_nist_test_doc_improvement(nist_add_txtname,data,write_type);
    case 3
        diehard_add_txtname=[file_head,'.bin'];
        diehard_binary_improvement(diehard_add_txtname,data,method,write_type);
        nist_add_txtname=[file_head,'.txt'];
        write_nist_test_doc_improvement(nist_add_txtname,data,write_type);
    otherwise
        disp('out of range!');
end
end
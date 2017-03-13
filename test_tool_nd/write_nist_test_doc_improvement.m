function write_nist_test_doc_improvement(address_nist_test_doc,data,write_type)
%write_nist_test_doc_improvement('E:\matlab\dataprocessing\auto_test_corr\test_tool_nd\huye.txt',data);
%生成nist测试文件8e6需要6min钟
if write_type==0
    data=reshape(data,25,[])';
    dlmwrite(address_nist_test_doc,data,'delimiter','','newline','pc');
else
    data=data(1:floor(length(data/25))*25);
    data=reshape(data,25,[])';
    dlmwrite(address_nist_test_doc,data,'-append','delimiter','','newline','pc');
end
    % type(address_nist_test_doc);
end

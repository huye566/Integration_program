function write_nist_test_doc(address_nist_test_doc,data)
%����nist�����ļ�
data_fidwrite=fopen(address_nist_test_doc,'w');
data_length=length(data);
data_integer=floor(data_length/25);
data_remain=data_length-data_integer*25;
progress_bar=waitbar(0,'�����ĵ�д�����');
for i=1:data_integer
    for j=1:25
    fprintf(data_fidwrite,'%d',data((i-1)*25+j));
    end
    if(i==data_integer&&data_remain==0)     
    else
    fprintf(data_fidwrite,'\r\n');
    end
%     if(mod(i,floor(data_integer/100))==0)
%         sprintf('�����ĵ�д����ȣ�%d%%',floor(i/data_integer*100))
%     end    
    waitbar(i/data_integer,progress_bar)
end
for i=1:data_remain
    fprintf(data_fidwrite,'%d',data(data_integer*25+i));
end
close(progress_bar)
sprintf('�����ĵ�д����ȣ�all is ok')
fclose(data_fidwrite);
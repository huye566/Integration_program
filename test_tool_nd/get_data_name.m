function data_name=get_data_name(channel_name,label_am,loop,data_name,filestyle)
%data_name=get_data_name(channel_name,label_am,loop,data_name,'.dat')
%��һ���ļ���ͬ,�ļ�����С��10000
for i=1:label_am
     if loop<10
          data_name{1,i}=[channel_name,'_0000',num2str(loop),'_',num2str(i),filestyle];
     else if loop<100
          data_name{1,i}=[channel_name,'_000',num2str(loop),'_',num2str(i),filestyle];
            else if loop<1000
                     data_name{1,i}=[channel_name,'_00',num2str(loop),'_',num2str(i),filestyle];
                   else
                        data_name{1,i}=[channel_name,'_0',num2str(loop),'_',num2str(i),filestyle];
                  end
           end
     end
 end
 end
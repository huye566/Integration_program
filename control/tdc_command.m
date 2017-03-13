function [isok,BW,temp]=tdc_command(obj,command)
BW=[];
fopen(obj);
fprintf(obj,command);
isok=0;
pause(0.4);
temp=cell(1,30);
for i=1:30
     back_data=get(obj,'BytesAvailable');
     %back_data=obj.BytesAvailable;
     if back_data>=1
          temp{i}=fscanf(obj);
     else
          length_data=i-1;
          break;
     end
end
fclose(obj);
information='';
for i=1:length_data
    information=[information,temp{i}];
end
if strcmp(command,'ds')==1
%     if strcmp(temp{length_data-1},[char(13)','DS STA: OK',char(13,10)'])==1;
  if length_data<2
        disp('tdc reading is error!');  
  else
      if isempty(strfind(temp{length_data-1},'OK'))~=1
        isok=1; 
        BW_temp=temp{length_data-2};
        idx=strfind(BW_temp,'GHz');
        BW=BW_temp(idx-6:idx-2);
        disp(information);
      else
            disp('waiting........................');
      end
  end
else
    disp(information);
end
temp=temp(1:length_data);
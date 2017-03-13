function bandwidth_3dB=get_3db_bandwidth(x_data,y_data)
bandwidth_3dB=0;
max_y_data=max(y_data);
max_y_data_index=find(y_data==max_y_data);
num_max_y_data=length(find(y_data==max_y_data));
if num_max_y_data>1
    disp('multiple max value!');
    return
end
value_3dB=max_y_data-3;
y_data_left=y_data(1:max_y_data_index);
y_data_right=y_data(max_y_data_index:end);
temp_low_left=find(y_data_left<=value_3dB);
temp_low_right=find(y_data_right<=value_3dB);
if isempty(temp_low_left)||isempty(temp_low_right)
    disp('range of data less than 3 dB!');
else
    position_1=x_data(temp_low_left(end));
position_2=x_data(temp_low_right(1)+max_y_data_index-1);
index_position_1=temp_low_left(end);
index_position_2=temp_low_right(1)+max_y_data_index-1;
x1=position_1;
x2=x_data(index_position_1+1);
y1=y_data(index_position_1);
y2=y_data(index_position_1+1);
x_left=(value_3dB-y1)*(x1-x2)/(y1-y2)+x1;
x2=position_2;
x1=x_data(index_position_2-1);
y2=y_data(index_position_2);
y1=y_data(index_position_2-1);
x_right=(value_3dB-y1)*(x1-x2)/(y1-y2)+x1;
bandwidth_3dB=x_right-x_left;
end


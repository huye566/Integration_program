function [block19_info,block20_info]=Crap_test(log_obj)
label_value_win=find(strcmp(log_obj.log_info(log_obj.label_block(14)+1:end),'wins:')==1);
label_value_game=find(strcmp(log_obj.log_info(log_obj.label_block(14)+1:end),'throws/game:')==1);
if length(label_value_win)~=2
    block19_info=1;
else
    label_value_win=label_value_win+log_obj.label_block(14);
    block19_info=str2double(log_obj.log_info{1,label_value_win(end)+1});
end
if isempty(label_value_game)
    block20_info=1;
else
    label_value_game=label_value_game+log_obj.label_block(14);
    block20_info=str2double(log_obj.log_info{1,label_value_game+1});
end    
function page_num=find_page_num(selection)
selection.Fields.Add(selection.Range,[],'Page');
%temp=selection.MoveLeft;%������9ҳ��������
temp=selection.HomeKey;
temp=-25-temp;
for i=0:1:temp
selection.MoveEnd;
end
page_num=floor(str2double(selection.Text));
selection.TypeBackspace;
end
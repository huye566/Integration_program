function  footer_line_num=find_footerdistance(selection)
footer_line_num=0;
% reference_step=20;
reference_step2=10;
start_page_num=find_page_num(selection);
%一级循环
% page_num=start_page_num;
% while(page_num==start_page_num)
%     for i=1:reference_step
%         selection.TypeParagraph;
%     end
%     page_num=find_page_num(selection);
%     footer_line_num=footer_line_num+reference_step;
% end
% footer_line_num=footer_line_num-reference_step;
% for i=1:reference_step
% selection.TypeBackspace;
% end
%二级循环
page_num=start_page_num;
while(page_num==start_page_num)
    for i=1:reference_step2
        selection.TypeParagraph;
    end
    page_num=find_page_num(selection);
    footer_line_num=footer_line_num+reference_step2;
end
footer_line_num=footer_line_num-reference_step2;
for i=1:reference_step2
selection.TypeBackspace;
end
%三级循环
page_num=start_page_num;
while(page_num==start_page_num)
    selection.TypeParagraph;
    page_num=find_page_num(selection);
    footer_line_num=footer_line_num+1;
end
for i=1:footer_line_num
selection.TypeBackspace;
end
footer_line_num=footer_line_num-1;
 
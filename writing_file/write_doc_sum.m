function  tabel_end_num=write_doc_sum(handle_pic,filespec,table_start_num,collapse,page_down_command)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%常量参数
tabel_end_num=table_start_num+1;%表格加1
try
     %若word服务器已经打开，返回其句柄Word
      Word = actxGetRunningServer('Word.Application');
catch
      %创建一个Microsoft Word服务器，返回句柄Word
      Word = actxserver('Word.Application');
end;
set(Word, 'Visible', 1); %或Word.Visible=1;
if exist(filespec,'file')%文件名为xiezh，不存在则存为myowe
    document = Word.Documents.Open(filespec);
    %document = invoke(Word.Documents,'Open',filespec);
else
   %document = invoke(Word.Documents, 'Add');
   document=Word.Documents.Add;
   document.SaveAs2(filespec);%Word已经改版
end
%定义接口
content = document.Content;%content接口写入文字内容
% duplicate = content.Duplicate;%复制
% inlineshapes = content.InlineShapes;
% paragraphs=document.Paragraphs;%段落接口
selection = Word.Selection;%selection接口区域操作

%paragraphformat = selection.ParagraphFormat;
%页面设置%setpage(document);
document.PageSetup.TopMargin = 60;%单位像素
document.PageSetup.BottomMargin = 45;
document.PageSetup.LeftMargin = 45;
document.PageSetup.RightMargin = 45;
% content.InsertParagraphAfter;% 插入一段
% content.Collapse=0; % 0为不覆盖
%设置标题

if collapse==0
    %set(content, 'Start',0);
    content.Start=0;%设置文档内容的起始位置
else
    end_label=selection.MoveDown;
    while(end_label==1)
        end_label=selection.MoveDown;
    end
    content.start=selection.start;
    content.end=selection.start;
end

if table_start_num==1
title='实验结果';
content.Text=title;
selection.start=0;
selection.MoveEnd;
selection.MoveEnd;
selection.MoveEnd;
selection.MoveEnd;
%set(content, 'Text',title);
%set(paragraphformat, 'Alignment','wdAlignParagraphCenter');%居中对齐
selection.ParagraphFormat.Alignment='wdAlignParagraphCenter';
selection.Font.Size=16;%设置字号为16，大小设置
selection.Font.Bold=4;%加粗设置
selection.EndKey;%用于取消选中,HomeKey
end
selection.TypeParagraph;%next line
%set(paragraphformat, 'Alignment','wdAlignParagraphLeft');
selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
selection.ParagraphFormat.FirstLineIndent=20;
selection.Font.Size=10.5;%设置字号
selection.Font.Bold=4;%加粗

footer_line_num=find_footerdistance(selection);
if footer_line_num~=46&&table_start_num~=1
    if footer_line_num<20||page_down_command==1
        for i=1:footer_line_num+1
            selection.TypeParagraph;
        end
    end
end
stm=['表格',num2str(table_start_num),':总结说明'];
selection.Text=stm;
%     set(selection, 'Text',stm);
selection.MoveDown;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end_of_doc = get(content,'end');%获得文档内容的末尾
%     set(selection,'Start',end_of_doc);%区域操作起始位置为文档尾
    %插入表格
%%%    selection.TypeParagraph;%回车，另起一段
selection.TypeParagraph;
   
table=document.Tables.Add(selection.Range,1,1);%光标位置插入行列表格
    %设置边框
%     table.Delete;
selection.MoveDown;

DTI=document.Tables.Item(table_start_num);
DTI.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI.Borders.InsideLineStyle='wdLineStyleSingle';
DTI.Borders.InsideLineWidth='wdLineWidth150pt';
DTI.Rows.Alignment='wdAlignRowCenter';
DTI.Columns.Item(1).Width =500;
DTI.Rows.Item(1).Height =120;

%         DTI.Cell(k,j).VerticalAlignment='wdCellAlignVerticalCenter';
set(DTI.Cell(1,1),'VerticalAlignment','wdCellAlignVerticalCenter');%表格对其
set(DTI.Cell(1,1).Range.ParagraphFormat,'Alignment','wdAlignParagraphCenter');%文字对齐

hgexport(handle_pic,'-clipboard');
DTI.Cell(1,1).Range.Paragraphs.Item(1).Range.Paste;%1表示第一段
delete(handle_pic);
document.ActiveWindow.ActivePane.View.Type = 'wdPrintView'; % 设置视图方式为页面
selection.ParagraphFormat.FirstLineIndent=25;
selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
 
end


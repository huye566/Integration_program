function  tabel_end_num=write_doc_sum(handle_pic,filespec,table_start_num,collapse,page_down_command)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��������
tabel_end_num=table_start_num+1;%����1
try
     %��word�������Ѿ��򿪣���������Word
      Word = actxGetRunningServer('Word.Application');
catch
      %����һ��Microsoft Word�����������ؾ��Word
      Word = actxserver('Word.Application');
end;
set(Word, 'Visible', 1); %��Word.Visible=1;
if exist(filespec,'file')%�ļ���Ϊxiezh�����������Ϊmyowe
    document = Word.Documents.Open(filespec);
    %document = invoke(Word.Documents,'Open',filespec);
else
   %document = invoke(Word.Documents, 'Add');
   document=Word.Documents.Add;
   document.SaveAs2(filespec);%Word�Ѿ��İ�
end
%����ӿ�
content = document.Content;%content�ӿ�д����������
% duplicate = content.Duplicate;%����
% inlineshapes = content.InlineShapes;
% paragraphs=document.Paragraphs;%����ӿ�
selection = Word.Selection;%selection�ӿ��������

%paragraphformat = selection.ParagraphFormat;
%ҳ������%setpage(document);
document.PageSetup.TopMargin = 60;%��λ����
document.PageSetup.BottomMargin = 45;
document.PageSetup.LeftMargin = 45;
document.PageSetup.RightMargin = 45;
% content.InsertParagraphAfter;% ����һ��
% content.Collapse=0; % 0Ϊ������
%���ñ���

if collapse==0
    %set(content, 'Start',0);
    content.Start=0;%�����ĵ����ݵ���ʼλ��
else
    end_label=selection.MoveDown;
    while(end_label==1)
        end_label=selection.MoveDown;
    end
    content.start=selection.start;
    content.end=selection.start;
end

if table_start_num==1
title='ʵ����';
content.Text=title;
selection.start=0;
selection.MoveEnd;
selection.MoveEnd;
selection.MoveEnd;
selection.MoveEnd;
%set(content, 'Text',title);
%set(paragraphformat, 'Alignment','wdAlignParagraphCenter');%���ж���
selection.ParagraphFormat.Alignment='wdAlignParagraphCenter';
selection.Font.Size=16;%�����ֺ�Ϊ16����С����
selection.Font.Bold=4;%�Ӵ�����
selection.EndKey;%����ȡ��ѡ��,HomeKey
end
selection.TypeParagraph;%next line
%set(paragraphformat, 'Alignment','wdAlignParagraphLeft');
selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
selection.ParagraphFormat.FirstLineIndent=20;
selection.Font.Size=10.5;%�����ֺ�
selection.Font.Bold=4;%�Ӵ�

footer_line_num=find_footerdistance(selection);
if footer_line_num~=46&&table_start_num~=1
    if footer_line_num<20||page_down_command==1
        for i=1:footer_line_num+1
            selection.TypeParagraph;
        end
    end
end
stm=['���',num2str(table_start_num),':�ܽ�˵��'];
selection.Text=stm;
%     set(selection, 'Text',stm);
selection.MoveDown;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end_of_doc = get(content,'end');%����ĵ����ݵ�ĩβ
%     set(selection,'Start',end_of_doc);%���������ʼλ��Ϊ�ĵ�β
    %������
%%%    selection.TypeParagraph;%�س�������һ��
selection.TypeParagraph;
   
table=document.Tables.Add(selection.Range,1,1);%���λ�ò������б��
    %���ñ߿�
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
set(DTI.Cell(1,1),'VerticalAlignment','wdCellAlignVerticalCenter');%������
set(DTI.Cell(1,1).Range.ParagraphFormat,'Alignment','wdAlignParagraphCenter');%���ֶ���

hgexport(handle_pic,'-clipboard');
DTI.Cell(1,1).Range.Paragraphs.Item(1).Range.Paste;%1��ʾ��һ��
delete(handle_pic);
document.ActiveWindow.ActivePane.View.Type = 'wdPrintView'; % ������ͼ��ʽΪҳ��
selection.ParagraphFormat.FirstLineIndent=25;
selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
 
end


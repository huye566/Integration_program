function  tabel_end_num=write_doc(handle_pic,table_info,filespec,table_start_num,collapse,page_down_command)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��������
cellcol=4;
cellrow=7;
column_width=[70,50,60,60,60,80,120];%�п���ĿΪ����
row_height=[12,12,12,120];
tabel_end_num=table_start_num+1;
try
     %��word�������Ѿ��򿪣���������Word
      Word = actxGetRunningServer('Word.Application');
catch
      %����һ��Microsoft Word�����������ؾ��Word
      Word = actxserver('Word.Application');
end;
set(Word, 'Visible', 1); %��Word.Visible=1;
if exist(filespec,'file') %�ļ���Ϊxiezh�����������Ϊmyowe
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
title='ʵ���¼';
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
if footer_line_num~=46&&table_start_num~=1%47�У��������һ�е�ֵΪ0����������Ϊ46
    if footer_line_num<20||page_down_command==1
        for i=1:footer_line_num+1
            selection.TypeParagraph;
        end
    end
end

stm=['���',num2str(table_start_num),':'];
selection.Text=stm;
%     set(selection, 'Text',stm);
selection.MoveDown;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     end_of_doc = get(content,'end');%����ĵ����ݵ�ĩβ
%     set(selection,'Start',end_of_doc);%���������ʼλ��Ϊ�ĵ�β
    %������
%%%    selection.TypeParagraph;%�س�������һ��
selection.TypeParagraph;
   
table=document.Tables.Add(selection.Range,cellcol,cellrow);%���λ�ò������б��
    %���ñ߿�
%     table.Delete;
for j=1:4
   selection.MoveDown;
end
DTI=document.Tables.Item(table_start_num);
DTI.Borders.OutsideLineStyle='wdLineStyleSingle';
DTI.Borders.OutsideLineWidth='wdLineWidth150pt';
DTI.Borders.InsideLineStyle='wdLineStyleSingle';
DTI.Borders.InsideLineWidth='wdLineWidth150pt';
DTI.Rows.Alignment='wdAlignRowCenter';
for j=1:cellrow
     DTI.Columns.Item(j).Width =column_width(j);
end
for j=1:cellcol
     DTI.Rows.Item(j).Height =row_height(j);
end
for k=1:cellcol
    for j=1:cellrow
        if k==1
            DTI.Cell(k,j).Shading.BackgroundPatternColor='wdColorSkyBlue';
        end
%         DTI.Cell(k,j).VerticalAlignment='wdCellAlignVerticalCenter';
        set(DTI.Cell(k,j),'VerticalAlignment','wdCellAlignVerticalCenter');%������
        set(DTI.Cell(k,j).Range.ParagraphFormat,'Alignment','wdAlignParagraphCenter');%���ֶ���
        if k<3
        DTI.Cell(k,j).Range.Text =table_info{k,j};
        end
    end
end
%�ڱ���в������������֣���ʽ���£�


%�ϲ���Ԫ��   
%    3��4�кϲ�
DTI.Cell(3,1).Merge(DTI.Cell(3,cellrow));
DTI.Cell(4,1).Merge(DTI.Cell(4,cellrow));
DTI.Cell(3,1).Merge(DTI.Cell(4,1));

%insert the pic
% handle_pic=figure(1);
% set(handle_pic, 'Visible', 'off');
% pic_data=imread(pic_address);
% image(pic_data);
hgexport(handle_pic,'-clipboard');
DTI.Cell(3,1).Range.Paragraphs.Item(1).Range.Paste;%1��ʾ��һ��
delete(handle_pic);
document.ActiveWindow.ActivePane.View.Type = 'wdPrintView'; % ������ͼ��ʽΪҳ��
%wdWrapSquare  0 ������  wdWrapTight  1 ������ wdWrapThrough 2 ��Խ��
%4 ������  5���������·�  6���������Ϸ�
%selection.InsertNewPage;%����հ�ҳ
%���������
% selection.TypeParagraph;
selection.ParagraphFormat.FirstLineIndent=25;
selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
    
% selection.TypeParagraph;
% selection.TypeParagraph;
% selection.ParagraphFormat.Alignment='wdAlignParagraphLeft';
% selection.Text='�������';
% selection.MoveDown;
%     
% %     shape=document.Shapes;
% %     shapecount=shape.Count;
% %     if shapecount~=0;
% %         for i=1:shapecount
% %             shap.Item(i).Delete
% %         end
% %     end
% selection.TypeParagraph;
% selection.Paste;
% selection.TypeParagraph;
%     
%  for i=1:18
%      selection.TypeParagraph;
%  end
%  for i=1:18
%      selection.MoveUp;
% end
% shape=document.Shapes.AddPicture('C:\Users\li\Desktop\huye.jpg',[],[],30,20,450,250);
% for i=1:18
%      selection.MoveDown;
% end
%    
% %document.ActiveWindow.ActivePane.View.Type = 'wdPrintView'; %
% %������ͼ��ʽΪҳ��
% %     document.Save;   %�Զ��������棬�û�ѡ���ļ����뱣��·��
% %     document.Close;%�ر��ĵ�
% %     Word.Quit;%�˳�word������
%     
    
end


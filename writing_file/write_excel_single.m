function  write_excel_single(filespec,data,data_range)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��������
try
     %��word�������Ѿ��򿪣���������Word
      Excel = actxGetRunningServer('Excel.Application');
catch
      %����һ��Microsoft Word�����������ؾ��Word
      Excel = actxserver('Excel.Application');
end;
set(Excel, 'Visible', 0); %��Word.Visible=1;
if exist(filespec,'file'); %�ļ���Ϊxiezh�����������Ϊmyowe
    Workbook = Excel.Workbooks.Open(filespec);
    %Workbook = invoke(Word.Workbooks,'Open',filespec);
else
   %document = invoke(Word.Workbooks, 'Add');
   Workbook=Excel.Workbooks.Add;
   Workbook.SaveAs(filespec);%Word�Ѿ��İ�
end
%���ص�ǰ��������
%Sheets=Excel.ActiveWorkbook.Sheets;
try
    sheets=Workbook.Sheets;%wps
catch
    sheets=Excel.ActiveWorkbook.Sheets;%office
end

for i=1:1
sheet=sheets.Item(i);%���ص�һ�����ľ��
sheet.Activate;%�����һ�����
sheet.Name=['Sheet',num2str(i)];
sheet.Range('A:K').Font.size = 10.5;
sheet.Range('A1:K1').ColumnWidth =11;
sheet.Range('A1:K1').Borders.Weight = 3;
%sheet.Range('A1:J1').Borders.Item(1).Linestyle = 0;
% д�뵥Ԫ������
sheet.Range(data_range).Value=data;%dataΪ������
end
 Workbook.Save   % �����ĵ�
 Workbook.Close   %�˳�����excel���������У�ע��
end


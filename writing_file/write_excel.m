function  write_excel(filespec,data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��������
%  data=zeros(4,9,3);
%  filespec='C:\Users\li\Desktop\huye1.xlsx';
%  data(1,3,1)=0.123133344133;
sheet_num=3;
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
try
    sheets=Workbook.Sheets;%wps
catch
    sheets=Excel.ActiveWorkbook.Sheets;%office
end
try
    sheets.Item(sheet_num);%���ص�һ�����ľ��
catch
    for i=(sheets.count+1):sheet_num
    sheets.Add;
    end
end
for i=1:sheet_num
        sheet=sheets.Item(i);%���ص�һ�����ľ��
        sheet.Activate;%�����һ�����
        sheet.Name=[num2str((4-i)*2),'0mV'];
        sheet.Range('A:J').Font.size = 10.5;
        sheet.Range('A1:J1').ColumnWidth =11;
        sheet.Range('A1:J1').Borders.Weight = 3;
        %sheet.Range('A1:J1').Borders.Item(1).Linestyle = 0;
        % д�뵥Ԫ������
        sheet.Range('A1:J1').Value = {'Dispersion','ICO','ACF(+)','tds(+)','ACF(-)','tds(-)','median','mean','symmetry','ACF'};
        position_str=['A',num2str(2),':J',num2str(length(data(1:end,1,i))+1)];
        sheet.Range(position_str).Value=data(1:end,1:end,i);%dataΪ������
end
Workbook.Save   % �����ĵ�
Workbook.Close   %�˳�����excel���������У�ע��
    
end


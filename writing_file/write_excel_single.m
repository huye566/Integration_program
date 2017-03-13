function  write_excel_single(filespec,data,data_range)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%常量参数
try
     %若word服务器已经打开，返回其句柄Word
      Excel = actxGetRunningServer('Excel.Application');
catch
      %创建一个Microsoft Word服务器，返回句柄Word
      Excel = actxserver('Excel.Application');
end;
set(Excel, 'Visible', 0); %或Word.Visible=1;
if exist(filespec,'file'); %文件名为xiezh，不存在则存为myowe
    Workbook = Excel.Workbooks.Open(filespec);
    %Workbook = invoke(Word.Workbooks,'Open',filespec);
else
   %document = invoke(Word.Workbooks, 'Add');
   Workbook=Excel.Workbooks.Add;
   Workbook.SaveAs(filespec);%Word已经改版
end
%返回当前工作表句柄
%Sheets=Excel.ActiveWorkbook.Sheets;
try
    sheets=Workbook.Sheets;%wps
catch
    sheets=Excel.ActiveWorkbook.Sheets;%office
end

for i=1:1
sheet=sheets.Item(i);%返回第一个表格的句柄
sheet.Activate;%激活第一个表格
sheet.Name=['Sheet',num2str(i)];
sheet.Range('A:K').Font.size = 10.5;
sheet.Range('A1:K1').ColumnWidth =11;
sheet.Range('A1:K1').Borders.Weight = 3;
%sheet.Range('A1:J1').Borders.Item(1).Linestyle = 0;
% 写入单元格内容
sheet.Range(data_range).Value=data;%data为行数组
end
 Workbook.Save   % 保存文档
 Workbook.Close   %退出但是excel程序还在运行，注意
end


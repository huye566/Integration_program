function  write_doc_save(filespec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%常量参数
try
     %若word服务器已经打开，返回其句柄Word
      Word = actxGetRunningServer('Word.Application');
catch
      %创建一个Microsoft Word服务器，返回句柄Word
      Word = actxserver('Word.Application');
end;
set(Word, 'Visible', 1); %或Word.Visible=1;
if exist(filespec,'file'); %文件名为xiezh，不存在则存为myowe
    document = Word.Documents.Open(filespec);
    %document = invoke(Word.Documents,'Open',filespec);
else
   %document = invoke(Word.Documents, 'Add');
   document=Word.Documents.Add;
   document.SaveAs2(filespec);%Word已经改版
end
     document.Save;   %自动弹出界面，用户选择文件夹与保存路径
     document.Close; 
%        
end


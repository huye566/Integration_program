function  write_doc_save(filespec)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%��������
try
     %��word�������Ѿ��򿪣���������Word
      Word = actxGetRunningServer('Word.Application');
catch
      %����һ��Microsoft Word�����������ؾ��Word
      Word = actxserver('Word.Application');
end;
set(Word, 'Visible', 1); %��Word.Visible=1;
if exist(filespec,'file'); %�ļ���Ϊxiezh�����������Ϊmyowe
    document = Word.Documents.Open(filespec);
    %document = invoke(Word.Documents,'Open',filespec);
else
   %document = invoke(Word.Documents, 'Add');
   document=Word.Documents.Add;
   document.SaveAs2(filespec);%Word�Ѿ��İ�
end
     document.Save;   %�Զ��������棬�û�ѡ���ļ����뱣��·��
     document.Close; 
%        
end


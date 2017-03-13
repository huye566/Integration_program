function Input = inpchk(Value_set,Val_lim,Eq_perm)
%���ڼ��������Ƿ���һ����ֵ��NaN��ʾ����ֵ
%Eq_perm:1: allowing equalling the min/max value
%        0: not allowing equalling the min/max value
if isnan(Value_set)
    %����dotnet�е�C#���룬���Value_set����ֵ������ʾ�����漰MCRInstaller����dll����̬������
    NET.addAssembly('System.Windows.Forms');%���ô��嶯̬��
    import System.Windows.Forms.*;%���봰��������ࡰ*��
%     switch Eq_perm % deal later
%         case 1
%         case 2
%         case 3
%         case 4
%     end
    Mess = ['Please input a number between [', num2str(Val_lim(1)), ',',...
        num2str(Val_lim(2)), ']!'];
    MessageBox.Show(Mess,'Error',MessageBoxButtons.OK,MessageBoxIcon.Error);
    Input = NaN;
else
    %Value_set����ֵ��Eq_perm����С���ȣ��������ֵ����Val_lim(1)~Val_lim(2)֮�䣬�������ȴ���ǳ�����˼������ѧϰһ��
    if Value_set+Eq_perm(1)*1e-9 <= Val_lim(1) || Value_set-Eq_perm(2)*1e-9 >= Val_lim(2)
        NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        Mess = ['Please input a number between ', num2str(Val_lim(1)), ',',...
        num2str(Val_lim(2)), '!'];%�������ֵ��Val_lim(1)~Val_lim(2)֮��
        MessageBox.Show(Mess,'Error',MessageBoxButtons.OK,MessageBoxIcon.Error);%�����򱨴�
        Input = NaN;%���������
    else
        Input = Value_set;
    end
end
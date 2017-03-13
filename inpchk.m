function Input = inpchk(Value_set,Val_lim,Eq_perm)
%用于检测输入的是否是一个数值，NaN表示非数值
%Eq_perm:1: allowing equalling the min/max value
%        0: not allowing equalling the min/max value
if isnan(Value_set)
    %调用dotnet中的C#代码，如果Value_set非数值，则提示报错，涉及MCRInstaller工具dll，动态依赖库
    NET.addAssembly('System.Windows.Forms');%调用窗体动态库
    import System.Windows.Forms.*;%导入窗体的所有类“*”
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
    %Value_set是数值，Eq_perm是最小精度，输入的数值不在Val_lim(1)~Val_lim(2)之间，报错，精度处理非常有意思，可以学习一下
    if Value_set+Eq_perm(1)*1e-9 <= Val_lim(1) || Value_set-Eq_perm(2)*1e-9 >= Val_lim(2)
        NET.addAssembly('System.Windows.Forms');
        import System.Windows.Forms.*;
        Mess = ['Please input a number between ', num2str(Val_lim(1)), ',',...
        num2str(Val_lim(2)), '!'];%输入的数值在Val_lim(1)~Val_lim(2)之间
        MessageBox.Show(Mess,'Error',MessageBoxButtons.OK,MessageBoxIcon.Error);%弹出框报错
        Input = NaN;%输入非数字
    else
        Input = Value_set;
    end
end
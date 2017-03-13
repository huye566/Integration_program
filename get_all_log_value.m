function [diehard_result,diehard_result_pass_info,diehard_result_temp,error_info]=get_all_log_value(label_block,log_info)
%block1_info=BS_test(log_obj);%zeros(1,1);
%block2_info=OPERM5_test(log_obj);%zeros(1,2);
%[block3_info,block4_info]=BB_31m31_and_32m32_test(log_obj);%zeros(1,1);
%block5_info=BB_6m8_test(log_obj);%zeros(1,1);
%block6_info=Bitstream_test(log_obj);%zeros(1,many);
%[block7_info,block8_info,block9_info]=OPSO_OQSO_DNA_test(log_obj)%zeros(1,many)not equal
%block10_info=Count_1_in_stream_test(log_obj);%zeros(1,many);
%block11_info=Count_1_in_specified_bits_test(log_obj);%zeros(1,many);
%block12_info=Parking_lot_test(log_obj);%zeros(1,1);
%block13_info=Minimum_Distance_test(log_obj);%zeros(1,1);
%block14_info=tripleD_Sphere_test(log_obj);%zeros(1,1);
% block15_info=Squeeze_test(log_obj);%zeros(1,1);
%block16_info=OSUM_test(log_obj);%zeros(1,1);
% [block17_info,block18_info]=RUN_test(log_obj);%block17_info=zeros(1,2);%block18_info=zeros(1,2);
%[block19_info,block20_info]=Crap_test(log_obj);%zeros(1,1);
diehard_result=zeros(1,19);
diehard_result_pass_info=cell(1,20);
diehard_result_temp=cell(1,15);
error_info=0;
if length(label_block)~=14
    disp('this log_info has missed some test!!');
    error_info=1;
else
log_obj=diehard_log(label_block,log_info);
temp_cell_2=cell(1,2);
temp_cell_3=cell(1,3);
diehard_result_temp{1,1}=BS_test(log_obj);%zeros(1,1);
diehard_result_temp{1,2}=OPERM5_test(log_obj);%zeros(1,2);
[temp_cell_2{1,1},temp_cell_2{1,2}]=BB_31m31_and_32m32_test(log_obj);%zeros(1,1);
diehard_result_temp{1,3}=temp_cell_2;
diehard_result_temp{1,4}=BB_6m8_test(log_obj);%zeros(1,1);
diehard_result_temp{1,5}=Bitstream_test(log_obj);%zeros(1,many);
[temp_cell_3{1,1},temp_cell_3{1,2},temp_cell_3{1,3}]=OPSO_OQSO_DNA_test(log_obj);%zeros(1,many)not equal
diehard_result_temp{1,6}=temp_cell_3;
diehard_result_temp{1,7}=Count_1_in_stream_test(log_obj);%zeros(1,many);
diehard_result_temp{1,8}=Count_1_in_specified_bits_test(log_obj);%zeros(1,many);
diehard_result_temp{1,9}=Parking_lot_test(log_obj);%zeros(1,1);
diehard_result_temp{1,10}=Minimum_Distance_test(log_obj);%zeros(1,1);
diehard_result_temp{1,11}=tripleD_Sphere_test(log_obj);%zeros(1,1);
diehard_result_temp{1,12}=Squeeze_test(log_obj);%zeros(1,1);
diehard_result_temp{1,13}=OSUM_test(log_obj);%zeros(1,1);
[temp_cell_2{1,1},temp_cell_2{1,2}]=RUN_test(log_obj);%block17_info=zeros(1,2);%block18_info=zeros(1,2);
diehard_result_temp{1,14}=temp_cell_2;
[temp_cell_2{1,1},temp_cell_2{1,2}]=Crap_test(log_obj);%zeros(1,1);
diehard_result_temp{1,15}=temp_cell_2;

%test
diehard_result(1)=diehard_result_temp{1,1};
diehard_result(2)=max(diehard_result_temp{1,2}(1),diehard_result_temp{1,2}(2));
diehard_result(3)=diehard_result_temp{1,3}{1,1};
diehard_result(4)=diehard_result_temp{1,3}{1,2};
diehard_result(5)=diehard_result_temp{1,4};
if length(find(diehard_result_temp{1,5}==1))>3
    diehard_result(6)=1;
else
    diehard_result(6)=max(diehard_result_temp{1,5}((diehard_result_temp{1,5}~=1)));
end
if length(find(diehard_result_temp{1,6}{1,1}==1))>3
    diehard_result(7)=1;
else
    diehard_result(7)=max(diehard_result_temp{1,6}{1,1}((diehard_result_temp{1,6}{1,1}~=1)));
end
if length(find(diehard_result_temp{1,6}{1,2}==1))>3
    diehard_result(8)=1;
else
    diehard_result(8)=max(diehard_result_temp{1,6}{1,2}((diehard_result_temp{1,6}{1,2}~=1)));
end
if length(find(diehard_result_temp{1,6}{1,3}==1))>3
    diehard_result(9)=1;
else
    diehard_result(9)=max(diehard_result_temp{1,6}{1,3}((diehard_result_temp{1,6}{1,3}~=1)));
end
diehard_result(10)=max(diehard_result_temp{1,7});
if length(find(diehard_result_temp{1,8}==1))>3
    diehard_result(11)=1;
else
    diehard_result(11)=max(diehard_result_temp{1,8}((diehard_result_temp{1,8}~=1)));
end
diehard_result(12)=max(diehard_result_temp{1,9});
diehard_result(13)=max(diehard_result_temp{1,10});
diehard_result(14)=max(diehard_result_temp{1,11});
diehard_result(15)=max(diehard_result_temp{1,12});
diehard_result(16)=max(diehard_result_temp{1,13});
diehard_result(17)=max(diehard_result_temp{1,14}{1,1});
diehard_result(18)=max(diehard_result_temp{1,14}{1,2});
diehard_result(19)=max(diehard_result_temp{1,15}{1,1});
sum_pass=0;
for i=1:length(diehard_result)
    if diehard_result(i)==1
        diehard_result_pass_info{1,i}='fail';
    else
        diehard_result_pass_info{1,i}='pass';
        sum_pass=sum_pass+1;
    end
end
diehard_result_pass_info{1,end}=num2str(sum_pass);
end



%���������������δ���
function data=binary32change(data)
%data=[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31];
data(1:16)=fftshift(data(1:16));
data(17:32)=fftshift(data(17:32));
data=fftshift(data);
function [RA,RP] = fun_rangeAP_calculation(L,Time_resolution,P_w,Sum_picture,nano_1_meter_0)
% Calculate of range accuracy and precision��the domain of calculation is exact the same as the duration of echo
%���Ǽ����ྫ�ȵľ��������㷨���������ʼ�������벨����ʼ���Ǻ�
% Copyright @ Zhijian Li
t_target = round(2*L/3e8/Time_resolution);
P_start = round(t_target-P_w/Time_resolution+1) +1;
P_end = round(t_target+P_w/Time_resolution) +1;
Sum = 0;
for i = P_start:P_end
    Sum = Sum + Sum_picture(i)*i;
end
A_bin = Sum/sum(Sum_picture(P_start:P_end)) - 0.5;

RA = A_bin-t_target-1;%accurracy  ����ʱ϶���������������ֵ

ind = (P_start:P_end); n = 1;%���β��n=1  %��ʽ�������2017��ʿ���ı�д
P_i_n = zeros(1,length(ind));
for i = 1:length(ind)
    P_i_n(i) = Sum_picture(ind(i));
end

sum1 = 0;
for i = 1:length(ind)
    sum1 = sum1 + P_i_n(i)*ind(i)^2;
end

sum2 = sum(P_i_n);

sum3 = 0;
for i = 1:length(ind)
    sum3 = sum3 + P_i_n(i)*ind(i);
end

RP = (sum1/sum2 - (sum3/sum2)^2)^0.5;

if nano_1_meter_0 == 1
    RA = RA*Time_resolution/1e-9;
    RP = RP*Time_resolution/1e-9;
else
    RA = RA*Time_resolution*1.5e8;
    RP = RP*Time_resolution*1.5e8;
end
end
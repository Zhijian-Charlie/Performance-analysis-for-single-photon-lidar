function [RA,RP] = fun_rangeAP_calculation_full_gate(L,Time_resolution,Sum_picture,nano_1_meter_0)
% Calculate of range accuracy and precision��the domain of calculation is
% same as the range gate
%���Ǽ����ྫ�ȵ�ȫ�������㷨�����쵥���嵥��̽���ھ������ڵ����ݷֲ�
% Copyright @ Zhijian Li
        t_target = round(2*L/3e8/Time_resolution);
        Sum = 0;
        for i = 1:length(Sum_picture)
            Sum = Sum + Sum_picture(i)*i;
        end
        A_bin = Sum/sum(Sum_picture);
     
        SUM = 0;
        for i = 1:length(Sum_picture)
            SUM = SUM + i^2*Sum_picture(i);
        end
        P_bin = SUM/sum(Sum_picture) - A_bin^2;
        P_bin = sqrt(abs(P_bin));
        RA = A_bin-t_target;%accurracy  ����ʱ϶���������������ֵ
        RP = P_bin;%precision ����ʱ϶���������������ֵ
        if nano_1_meter_0 == 1
            RA = RA*Time_resolution/1e-9;
            RP = RP*Time_resolution/1e-9;
        else 
            RA = RA*Time_resolution*1.5e8;
            RP = RP*Time_resolution*3.0e8;
        end
end
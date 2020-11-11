function [result_Pd, result_Pf, result_A, result_P, result_pdf, result_SNR, t, mark] = fun_comprehensive_analysis(L_set,noise_set,P_w_set,attenuation_set,N_pulse_set,gate_end,Time_dead_set,count_set)
% Core function for single-photon lidar performance analysis
% Copyright @ Zhijian Li

perfect_1_allgate_0 = 1;
SAVE = 0;                                                                  % SAVE the result�� 0=No��1=Yes % ����洢���� 0=��1=��
Time_resolution = 100e-12;                                   % Time resolution of timing circuit.Unit: 1ps %��ʱ��Ԫʱ��ֱ��ʣ���λ1ps
gate_loop = length(gate_end);                                % loop length of range gate %������ѭ�������ĸ���
noise_sum = noise_set*gate_end;                              % number of noise photon in one range gate %�������ڵ�����������
acm_set = 1;
%*****************************************************************************

for i0 = 1:gate_loop
    t = 0e-9:Time_resolution:gate_end(i0);                           % time axis %ʱ����
    c = 3e8;                                                % speed of light % ����  
    
    [~,time_channel_amount] = size(t);
    
    %***********************************************************************
    % Calculate the loop length of variables % ����ѭ�������ĸ���
    L_loop = length(L_set);
    noise_loop = length(noise_set);
    Time_dead_loop = length(Time_dead_set);
    attenuation_loop = length(attenuation_set);
    count_loop = length(count_set);
    acm_loop = length(acm_set);
    P_w_loop = length(P_w_set);
    N_pulse_set_loop = length(N_pulse_set);
    %**************************************************************************
    for i_attenuation = 1:attenuation_loop
        for i_P_w = 1:P_w_loop
            for i_acm = 1:acm_loop
                for i1 = 1:L_loop
                    for i2 = 1:noise_loop
                        gate_end(i0)*noise_set(i2);
                        for i3 = 1:Time_dead_loop
                            for i5 = 1:count_loop
                                i = 1;
                                mark = ' ';
                                if gate_loop>1
                                    i = i0;
                                    mark = gate_end/1e-9;
                                end
                                if count_loop>1
                                    i = i5;
                                    mark = count_set;
                                end
                                if L_loop>1
                                    i = i1;
                                    mark = L_set;
                                end
                                if noise_loop>1
                                    i = i2;
                                    mark = noise_set/1e6;
                                end
                                if Time_dead_loop>1
                                    i = i3;
                                    mark = Time_dead_set/1e-9;
                                end
                                if acm_loop>1
                                    i = i_acm;
                                    mark = acm_set;
                                end
                                if P_w_loop>1
                                    i = i_P_w;
                                    mark = P_w_set/1e-9;
                                end
                                if attenuation_loop>1
                                    i = i_attenuation;
                                    mark = attenuation_set;
                                end
                                for i4 = 1:N_pulse_set_loop
                                    i4
                                    count = count_set(i5);
                                    P_w = P_w_set(i_P_w);
                                    attenuation = attenuation_set(i_attenuation);
                                    L = L_set(i1)*gate_end(i0)*c/2/100;     % change 'L' into meter % ��L����Ϊ��ʵ���루�ף�
                                    noise = noise_set(i2)*attenuation;
                                    Time_dead = Time_dead_set(i3);
                                    acm = acm_set(i_acm);
                                    N_pulse = N_pulse_set(i4);
                                    Peak_signal_rate = 3*N_pulse/(4*P_w);                 % Peak flux rate of echo signal %�ز��źŹ�����ÿ������ķ�ֵ
                                    Peak_signal_rate = attenuation*Peak_signal_rate;
                                    [Poisson_PDF_total,T_jump] = fun_parabola_wave_pdf(Peak_signal_rate,t,Time_resolution,P_w,L,noise,Time_dead);
                                    
                                    % Preparation done %׼���������
                                    
                                    % The theoretical curve of the detection probability of single-photon 
                                    % �����Ӽ����״��������Ӧ����
                                    Sum_picture_thy = fun_theory_core_my_model( time_channel_amount,Poisson_PDF_total,T_jump );
                                    % Calulate the number of noise count per period
                                    % ����ÿ��̽�������ڵ���������ֵ
                                    [noise_trigger(i4), noise_bin_num] = fun_noise_trigger_quant(Sum_picture_thy,P_w,L,Time_resolution);
                                    % Calulate the number of signal count per period
                                    % ����ÿ��̽�������ڵ��źż���ֵ
                                    signal_trigger(i4) = fun_signal_trigger_quant(Sum_picture_thy,P_w,L,Time_resolution);
                                    SNR = signal_trigger(i4)/sqrt(signal_trigger(i4) + noise_trigger(i4)/noise_bin_num);
                                    nano_1_meter_0 = 0;
                                    % Calculate the theory range accuracy��RA��and range precision��RP��using single pulse %���ۼ�����׼ȷ��RA�;��ܶ�RP��������
                                    if perfect_1_allgate_0 == 1
                                        [RA,RP] = fun_rangeAP_calculation(L,Time_resolution,P_w,Sum_picture_thy,nano_1_meter_0);% Calculate of range accuracy and precision��the domain of calculation is exact the same as the duration of echo  %�����ྫ�ȵľ��������㷨���������ʼ�������벨����ʼ���Ǻ�
                                    else
                                        [RA,RP] = fun_rangeAP_calculation_full_gate(L,Time_resolution,Sum_picture_thy,nano_1_meter_0);% Calculate of range accuracy and precision��the domain of calculation is same as the duration of range gate%�����ྫ�ȵ�ȫ�������㷨�����쵥���嵥��̽������ݷֲ�������ֵ
                                    end
                                    % Calculation of false alarm
                                    % probability��Pf��and detection
                                    % probability ��Pd��
                                    % �����龯�ʣ�Pf����̽���ʣ�Pd��
                                    [Pd,Pf] = fun_DPFP_calculation(L,Time_resolution,P_w,Sum_picture_thy);

                                    result_Pd(i4,i) = Pd;
                                    result_Pf(i4,i) = Pf;
                                    result_A(i4,i) = RA;
                                    result_P(i4,i) = RP;
                                    result_SNR(i4,i) = SNR;
                                    result_pdf(i,:) = Sum_picture_thy;
                                    
                                    if count ~= 1
                                        % Detection probability��multiple pulses accumulation�� % ̽���ʣ��������ۼƣ�                                  
                                        P_det_count = fun_photon_count_P_det(Pd,count);
                                        % False alarm probability  ��multiple pulses accumulation�� % �龯�ʣ��������ۼƣ�
                                        P_FA_count = fun_photon_count_P_FA(L,Time_resolution,P_w,Sum_picture_thy,count);
                                        % RA and RP ��multiple pulses accumulation�� % RA��RP���������ۼƣ�
                                        [Ra_count, Rp_count] = fun_photon_count_Ra_Rp(L,Time_resolution,P_w,Sum_picture_thy,count,RA);
                                        result_Pd(i4,i) = P_det_count;
                                        result_Pf(i4,i) = P_FA_count;
                                        result_A(i4,i) = Ra_count;
                                        result_P(i4,i) = Rp_count;
                                        result_SNR(i4,i) = sqrt(count)*SNR;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
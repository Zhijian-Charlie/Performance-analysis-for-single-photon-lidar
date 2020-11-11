% Performance analysis for single-photon lidar under various working
% conditions. (The x axis in each plot is labled by the number of photon per echo)
% ��ͬ�����������Ӽ��������״�̽�������ۺϷ�����������Ϊ������ز���������ֵ��
% Copyright @ Zhijian Li
close all
clear
clc
tic

%**************************************************************************
% Key parameters for analysis %�仯�ؼ�����
% Note that there can only exsits one parameter that has multiple values in
% each analysis
% ע�⣬ÿ������ֻ����һ���������ж�ֵ
L_set = 50;                                             % The percentage of the target within the range gate %Ŀ��λ���ڳ���ʱ����λ�õİٷֱ�
noise_set = [10e6 15e6 20e6 30e6];                            % Nunber of noise photon per second %  ÿ�����������Ӹ���
P_w_set = 1e-9%[1e-9 5e-9 10e-9 20e-9];                             % Pulse width (ns) %������ ��ns��
Time_dead_set = 10e-9;%[50e-9 100e-9 200e-9 1000e-9]                          % Dead time (ns)  %����ʱ�� (ns)
count_set = 1%[1 3 5 7];    % Number of accumlated pulses for one detection��1 for default�� %ÿ��̽����õ������ۼƴ�����Ĭ����һ��

% Switch on the auto-label for plot�� %�Ƿ�����ͼ���߳����Զ���ע��
mark_or_not = 0; % 1= Yes��0= No %1=�ǣ�0=��
positon = 0.5; % The location of the auto-label��range from 0~1,1=the rightmost of the figure, 0=the leftmost of the figure %��ͼ�����Զ���ע��λ�ã�ȡֵ0~1��1=�������Ҳ࣬0=���������

% Defaut parameters
%Ĭ�ϲ���
gate_end = 400e-9;% Default range gate%     Ĭ�Ͼ����ų���ʱ��
N_pulse_set = 0.1:0.1:8;% Default number of photon per echo%    Ĭ�ϴ�0.1~8  %�����ز�����Ĺ�������ֵ
attenuation_set = 1;% Default attenuation coefficient (1=100% transparency��0=0% transparency)%          Ĭ�������˥��ϵ��Ϊ1 ��1������ȫ���䣬0����͸�⣩



%********************************
% Run the function of comprehensive analysis %�����ۺϷ���ģ��
[result_Pd, result_Pf, result_A, result_P, result_pdf, result_SNR, t, mark] = fun_comprehensive_analysis(L_set,noise_set,P_w_set,attenuation_set,N_pulse_set,gate_end,Time_dead_set,count_set);

%********************************
% Figure plotting %��ͼģ��
i1 = length(mark);
figure(1)
T = t*1e9;
plot(T,result_pdf);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(T)*positon);
        h = text(T(xh),result_pdf(ih,xh),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('ʱ����/ns') % Time axis
ylabel('ÿ��ʱ϶�ڵ�̽�����') % Detection probability per time bin
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);


figure(2)
plot(N_pulse_set,result_A);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(N_pulse_set)*positon);
        h = text(N_pulse_set(xh),result_A(xh,ih),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('������ز���������ֵ') % Number of photon per echo
ylabel('������/m') % Range error
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);

figure(3)
plot(N_pulse_set,result_P);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(N_pulse_set)*positon);
        h = text(N_pulse_set(xh),result_P(xh,ih),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('������ز���������ֵ')  % Number of photon per echo
ylabel('���������/m') % Mean square error of depth
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);

figure(4)
plot(N_pulse_set,result_Pd);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(N_pulse_set)*positon);
        h = text(N_pulse_set(xh),result_Pd(xh,ih),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('������ز���������ֵ')% Number of photon per echo
ylabel('Ŀ��̽����') % Detection probability of the target



set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);

figure(5)
plot(N_pulse_set,result_Pf);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(N_pulse_set)*positon);
        h = text(N_pulse_set(xh),result_Pf(xh,ih),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('������ز���������ֵ') % Number of photon per echo
if gate_end>Time_dead_set(1)
    ylabel('ÿ̽�����ڵ�������������'); % Expectation of noise photon per detection period
else
    ylabel('̽���龯��') % False alarm probability
end

set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);

figure(6)
plot(N_pulse_set,result_SNR);
if mark_or_not == 1
    for ih = 1:i1
        if mark(ih)<0.001
            mark(ih) = 0;
        end
        text_num = num2str(mark(ih));
        xh = floor(length(N_pulse_set)*positon);
        h = text(N_pulse_set(xh),result_SNR(xh,ih),text_num);s = h.FontSize;h.FontSize = 20;
    end
end
grid on
xlabel('������ز���������ֵ') % Number of photon per echo
ylabel('̽�������') % SNR for detection
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',1.5);
set(gca, 'Fontname', 'Times newman', 'Fontsize', 20);

toc

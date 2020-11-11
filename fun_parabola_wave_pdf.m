function [Poisson_PDF_total,T_jump] = fun_parabola_wave_pdf(Peak_signal_rate,t,Time_resolution,P_w,L,noise,Time_dead)
% Parabola waveform function��
% return the Poisson detection probability per time bin without the effect of dead time��Poisson_PDF_total
% return the number of time bins that the dead time occupies
%���Ӽ��������߲��η��棬���ز��ɸ����²���������ʱ��ЧӦ��ʱ϶��̽����ʷֲ�Poisson_PDF_total������ʱ������ʱ϶�ĸ���T_jump
% Copyright @ Zhijian Li

% Get the lenght of time bin %��ȡʱ϶����time_channel_amount
[~,time_channel_amount] = size(t);

% Calculate the time-of-flight %����Ŀ��ز��ĵ���ʱ��
t_target = 2*L/3e8;

% Build the rect function��because for parabola waveform the waveform is selected within a rect function %�������κ���rect0
rect0 = zeros(1, time_channel_amount);
for index = 1:time_channel_amount
    if (t(index) > t_target - P_w) && (t(index) < t_target + P_w)
        rect0(index) = 1;
    end
end

% Generate the parabola waveform, N, via rect function %���þ��κ���rect0�������õ�������ģ��N
N = Peak_signal_rate *Time_resolution* (1 - (  (t -  t_target)   ./   (P_w )  ).^2 ) .* rect0;

% Optimize the shape of parabola, to make sure it is exact symmetry %�Ż��������������ݣ�ʹ������ֵ�ֲ��ϰ��������������ϸ�Գ�
[~,Mn]=find(N==max(N));
bb = round(P_w/Time_resolution);
nr = N(Mn-bb+1:Mn);
nr = nr(end:-1:1);
[~,w] = size(nr);
[~,wn] = size(N);
NN = [N(1:Mn),nr,N(Mn+w+1:wn)];
N = NN;

% Add noise to the parabola waveform %���õ��������ߵ�����
S_noise1 = ones(1,time_channel_amount)*noise*Time_resolution;

% Calculate the number of time bins that dead time occupise %��������ʱ������ʱ϶�ĸ���
T_jump = floor(Time_dead / Time_resolution);

% Calculate the Poisson detection probability per time bin without the effect of dead time %���㲴�ɸ����²���������ʱ��ЧӦ��ʱ϶��̽����ʷֲ�Poisson_PDF_total
Poisson_PDF_total = 2 - exp(-N) - exp(-S_noise1);
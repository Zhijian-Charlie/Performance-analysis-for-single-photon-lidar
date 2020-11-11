function Sum_picture = fun_theory_core_my_model( time_channel_amount,Poisson_PDF_total,T_jump )
% The universal detection probability model from my previous paper Applied Optics , 56��23����6680-6687 
% �ҵ�ͨ�õĸǸ�ģʽAPD̽���������ģ�ͣ�������Applied Optics , 56��23����6680-6687 
% Copyright @ Zhijian Li

Sum_picture = zeros(1,time_channel_amount);
Sum_picture(1) = Poisson_PDF_total(1);
for k = 1:1:time_channel_amount-1
    d = T_jump;
    if k >=d
        Sum_picture(k+1) = (Sum_picture(k)*(1-Poisson_PDF_total(k))/Poisson_PDF_total(k) + Sum_picture(k-d+1))*Poisson_PDF_total(k+1);
    else
        Sum_picture(k+1) = Sum_picture(k)*(1-Poisson_PDF_total(k))*Poisson_PDF_total(k+1)/Poisson_PDF_total(k);
    end
end

end


%% ��ֵƵ�� - MDF - Median Frequency
function feature = f_mdf(data)
    
    Fs = 100;           
    feature = medfreq(data, Fs);    % medfreq()������ֵƵ��
    
end

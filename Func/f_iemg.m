function feature = f_iemg(data)
% ���ּ���ֵ iEMG
    t=0.01;
    feature=sum(abs(data)*t)/size(data,1);
end


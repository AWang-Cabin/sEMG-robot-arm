function result=g_testemg(model,rule,test,i,length_t)
%% ����ģ�ͳ���
% ����ѵ���õķ���ģ�Ͷ�δ֪���ݽ���Ԥ��
% model ѵ���õķ���ģ�ͣ����trainonline.m
% rule ѵ�����Ĺ�һ���������c_normal.m
% i ����������
% length_t ����������
% By Yinuo Wang 2020/4/15

    % ȡʱ�䴰������
    win= test(i:i+length_t,:);
    
    % Ԥ����
    delete=p_mean(win);% ȥƫ��
    out=p_outlier(delete);% ȥҰֵ
    filt=p_50hz(out);% �ݲ�
    filted=p_butter(filt);% �˲�
    
    % ��ֵ����
    datadetect=f_detect(filted);% �����ڻ����ֵ����������
    b=(datadetect==0);
    zeronum=sum(b(:));% ���������
    zeroratio=zeronum/length_t;%���������
    
    %�жϴ��ڻ�η�Χ
    if zeroratio < 0.4000
        
%         plot(i,0,'b+');%���ƻ�β�����



        feature=f_feature(filted,0);% ������ȡ
        
        F=c_normal_rule(feature,rule); % ���ݹ�һ��
        
        %����������ת����libsvm��ʶ��ĸ�ʽ
        instance=sparse(F(1,1:27));
        lab=F(1,28);
        libsvmwrite('emgtest3',lab, instance);
        
        % �Ի�η���Ԥ��
        [label, data] = libsvmread('emgtest3');% ��ȡ����
        predict = libsvmpredict(label,data,model);% ���ݷ���
        result=predict;
        
    else
        % �Ծ�Ϣ��ֱ������
        result=0;
    end


end
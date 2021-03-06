%% ����ģ�ͳ���
%����ѵ���õķ���ģ�Ͷ�δ֪���ݽ���Ԥ��
%% ����׼��
model=libsvmload('copymodel.model',27);% ���ط���ģ��
load('rule.mat');%���ع�һ������
% % ����xls���ݣ�����Ϊmat�ļ�
% test=xlsread('test1');%new1-5
% save new.mat new;
load('moni.mat');
%% Ԥ����
[delete,m1,m2,m3]=p_mean(monitor);% ȥƫ��
% delete(:,1)=test(:,1);
% delete(:,2)=test(:,2)+0.1789;
% delete(:,3)=test(:,3)+0.2053;
% delete(:,4)=test(:,4)+0.2047;
out=p_outlier(delete);% ȥҰֵ
filt=p_50hz(out);% �ݲ�
filted=p_butter(filt);% �˲�

figure(1)
plot(delete(:,2));
hold on;
grid on;
%% ������ȡ+����ʶ��
%���û�����˼�룬��ȡһ��ʱ�䴰length_t,��������Сdelta_t,��λms
length_t=100;
delta_t=20;
m=1; % ���ߴ���
result=[]; % ���߾���
tic
for i=1:delta_t:size(filted,1)
    % ����ѭ������
    if i+length_t>size(filted,1)
        break;
    end
      
    % ȡʱ�䴰
    win= filted(i:i+length_t,:);
    
    % ��ֵ����
    datadetect=f_detect(filted(i:i+length_t,:));% �����ڻ����ֵ����������
    b=(datadetect==0);
    zeronum=sum(b(:));% ���������
    zeroratio=zeronum/length_t;%���������
    
    %�жϴ��ڻ�η�Χ
    if zeroratio < 0.4000
 
        plot(i,0,'r+');%���ƻ�β�����
        
        feature=f_feature(win,0);% ������ȡ
        
        F=c_normal_rule(feature,rule); % ���ݹ�һ��
        
        %����������ת����libsvm��ʶ��ĸ�ʽ
        instance=sparse(F(1,1:27));
        lab=F(1,28);
        libsvmwrite('emgtest3',lab, instance);
        
        % �Ի�η���Ԥ��
        [label, data] = libsvmread('emgtest3');% ��ȡ����
        predict = libsvmpredict(label,data,model);% ���ݷ���
        result(m)=predict;
        
    else
        % �Ծ�Ϣ��ֱ������
        result(m)=0;
    end
    m=m+1;
end
%% ������

figure(3)
t=(1:20:20*length(result));% ����x�Ჽ��
stairs(t,result,'r.','markersize',20);
set(gca,'ytick',0:1:6);% ����y�Ჽ��
title('Predict Result');
grid on;

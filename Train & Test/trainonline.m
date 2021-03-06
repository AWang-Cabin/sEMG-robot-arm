%% ѵ��ģ�ͳ���
% ʹ���б�ǩ��ԭʼ�����ļ�raw.matѵ��ģ�ͣ�����ģ���ļ�copymodel����һ�������ļ�rule.mat

%% ����׼��
% % ����xls���ݣ�����Ϊmat�ļ�
% test=xlsread('test1');%new1-5
% save new.mat new;
load('raw.mat');

%% Ԥ����
delete=p_mean(raw);% ȥƫ��
out=p_outlier(delete);% ȥҰֵ
filt=p_50hz(out);% �ݲ�
filted=p_butter(filt);% �˲�

%% ������ȡ
labels = unique(filted(:,5));% ��ȡ����ǩlabels=[1,2,3,4,5]
label=filted(:,5);
for c=1:5 % ��5����ȡ����
    num = find(label == labels(c));% ��c�������������1-39398
  
    figure(c)
    plot(filted(num(1):num(size(num),1),2));
    hold on;
    
    % ����c���������ݵ�����newpart
    for k=1:length(num) 
        newpart(k,:)=filted(num(k),:);
    end

    % ���û�����˼�룬��ȡһ��ʱ�䴰length_t,��������Сdelta_t,��λms
    length_t=100;
    delta_t=20;
    j=1; %������
    feature=[]; %��ǰ�����ڴ�
    
    tic
    for i=1:delta_t:size(newpart,1)
        % ����ѭ������
        if i+length_t>size(newpart,1)% �ж��Ƿ񳬳����ݷ�Χ
            break;
        end

        % ��ֵ����
        datadetect=f_detect(newpart(i:i+length_t,:));     
        b=(datadetect==0);
        zeronum=sum(b(:));% ���������
        zeroratio=zeronum/length_t;%���������
        
        if zeroratio < 0.4000 %�жϴ��ڻ�η�Χ
            
            plot(i,0,'r+');;%���ƻ�β�����
            feature(j,:)=f_feature(newpart(i:i+length_t,:),c);% ������ȡ
            j=j+1;
            
        end
        
    end
    % ����������������
    if c==1
        x=feature;
    else
        x=[x;feature];
    end
    newpart=[];% �ͷ���ʱ����
    toc
end

%% ��һ��
[X,rule]=c_normal(x,0,1,27); % ��һ��
save rule.mat rule;% �����һ������

%����������ת����libsvm��ʶ��ĸ�ʽ
instance=sparse(X(:,1:27));
lab=X(:,28);
libsvmwrite('emg',lab, instance);


%% -- ѵ��ģ�� --%%
% ��ȡ���ݼ�
[label, data] = libsvmread('emg');

% ��������Ѱ��
% [bestacc,bestc,bestg]=SVMcgForClass(label,data,-8,8,-8,8,5,1,1); % c,gammaѰ��

% ����ѵ�����Ͳ��Լ�
ratio =0.8; %ѵ��������
[traindata, trainlabel, testdata, testlabel]= c_split(data,label,ratio);

% ѵ��ģ��
model = libsvmtrain(label,data,'-s 0 -t 2  -c 1 -g 1 ');

% ���ý�����ģ�Ϳ�����ѵ�������ϵķ���Ч��-w1 0.8 -w3 2.5 -w4 1 -w5 2
[ptrain,acctrain,~] = libsvmpredict(trainlabel,traindata,model);

% Ԥ����Լ��ϱ�ǩ
[ptest,acctest,test_dec_values] = libsvmpredict(testlabel,testdata,model);

% �������ģ��
libsvmsave(model,'copymodel.model');

% Ԥ�������ӻ�
figure(6)
p=[ptrain;ptest];
plot(p,'o');
grid on;
set(gca,'ytick',1:1:6);
% ��ȡ���ݼ�
[label, data] = libsvmread('emg');
%%
% i=1;
% % ����ѵ�����Ͳ��Լ�
% for g=[10e-5,10e-4,10e-3,10e-2:10e-1,1,10,100]
% ratio =0.7;%ѵ��������
% [traindata, trainlabel, testdata, testlabel]= c_split(data,label,ratio);
% 
% cmd = ['-s ',num2str(0),' -t ',num2str(2),' -v ',num2str(5),' -c ',num2str(4),' -g ',num2str(g)];
% cmdd= ['-s ',num2str(0),' -t ',num2str(2),' -c ',num2str(4),' -g ',num2str(g)];
% % % ѵ��ģ��
% valid(i)= libsvmtrain(trainlabel,traindata,cmd);
% 
% model= libsvmtrain(label,data,cmdd);
% % '-s 0 -t 2 -c num2str(c) -v 5 -q'
% % % ���ý�����ģ�Ϳ�����ѵ�������ϵķ���Ч��
% [ptrain,acctrain,~] = libsvmpredict(trainlabel,traindata,model);
% acc(i)=acctrain(1);
% % % Ԥ����Լ��ϱ�ǩ
% % [ptest,acctest,test_dec_values] = libsvmpredict(testlabel,testdata,model);
% i=i+1;
% end
% figure(4)
% gamma=[10e-5,10e-4,10e-3,10e-2:10e-1,1,10,100];
% semilogx(gamma,valid,'-rs',gamma,acc,'-b^','linewidth',2,'markersize',5);hold on;grid on;legend on;
% title('g��֤����');xlabel('g');ylabel('Accuracy/%');legend('validation accuracy','trainset accuracy ');
%%
i=1;

% ����ѵ�����Ͳ��Լ�
for c=[10e-4,10e-3,10e-2:10e-1,1,10,100,1000,10e3,10e4,10e5,10e6]
ratio =0.7;%ѵ��������
[traindata, trainlabel, testdata, testlabel]= c_split(data,label,ratio);

cmd = ['-s ',num2str(0),' -t ',num2str(2),' -v ',num2str(5),' -c ',num2str(c)];
cmdd= ['-s ',num2str(0),' -t ',num2str(2),' -c ',num2str(c)];
% % ѵ��ģ��
valid(i)= libsvmtrain(trainlabel,traindata,cmd);

model= libsvmtrain(label,data,cmdd);
% '-s 0 -t 2 -c num2str(c) -v 5 -q'
% % ���ý�����ģ�Ϳ�����ѵ�������ϵķ���Ч��
[ptrain,acctrain,~] = libsvmpredict(trainlabel,traindata,model);
acc(i)=acctrain(1);
% % Ԥ����Լ��ϱ�ǩ
% [ptest,acctest,test_dec_values] = libsvmpredict(testlabel,testdata,model);
i=i+1;
end
figure(5)
gamma= [10e-4,10e-3,10e-2:10e-1,1,10,100,1000,10e3,10e4,10e5,10e6];
semilogx(gamma,valid,'-rs',gamma,acc,'-b^','linewidth',2,'markersize',5);hold on;grid on;legend on;
title('c��֤����');xlabel('c');ylabel('Accuracy/%');legend('validation accuracy','trainset accuracy ');

%%
% i=1;
% for ratio =0.05:0.05:1%ѵ��������
% [traindata, trainlabel, testdata, testlabel]= c_split(data,label,ratio);
% % ѵ��ģ��
% valid(i)= libsvmtrain(trainlabel,traindata, '-s 0 -t 2 -c 4 -g 4 -v 5 -q');
% model= libsvmtrain(label,data, '-s 0 -t 2 -c 4 -g 4 -q');
% % ���ý�����ģ�Ϳ�����ѵ�������ϵķ���Ч��
% [ptrain,acctrain,~] = libsvmpredict(trainlabel,traindata,model);
% acc(i)=acctrain(1);
% i=i+1;
% end
% figure(5)
% ra=1000*(0.05:0.05:1);
% plot(ra,valid,'-rs',ra,acc,'-b^','linewidth',2,'markersize',5);hold on;grid on;legend on;
% title('ѧϰ����');xlabel('������');ylabel('Accuracy/%');legend('validation accuracy','trainset accuracy ');
% axis([0,1005,0,100]);
% t3=0.05*(1:9999); 
% % ch3,jpg
% subplot(3,1,1);
% plot(t3,raw(1:9999,2),'r'); 
% xlabel('t/s'); ylabel('U/mV');title('ch-1');
% 
% subplot(3,1,2); 
% plot(t3,raw(1:9999,3),'b');
% title('ch-2'); xlabel('t/s'); ylabel('U/mV');
% 
% subplot(3,1,3);
% plot(t3,raw(1:9999,4),'y'); 
% xlabel('t/s');title('ch-3'); ylabel('U/mV');1000:2999


% a=raw(10001:12000,3);
% t=0.05*(1:2000);
% aout=p_outlier(raw(10001:12000,:));
% figure(2);
% subplot(1,2,1);plot(t,a,'b');grid on;title('ԭʼ�ź�');xlabel('t/s');ylabel('U/mV');
% subplot(1,2,2);plot(t,aout(:,3),'b');grid on;title('ȥƫ���ź�');xlabel('t/s');ylabel('U/mV');


%% FFT Ƶ�׷���
fs=2000;%����Ƶ�ʣ���λHz y
% n=0:N-1;
% N=length(t);
N=50000;t=(N-1)/fs;
for i=1:50000
   y=5*10e-6*sin(100*pi*0.0005*i); k(i)=b(i,1)+y;
end
fx=fft(k,N);
fx=abs(fx(1:round(N/2-1)));
figure(3)
subplot(1,2,1);
plot((1:round(N/2-1))*fs/N,fx);%�����źŵ�Ƶ�ף������Ӧʵ��Ƶ��
grid on;title('ԭʼ�ź�Ƶ��ͼ');xlabel('f/Hz');ylabel('���');


%% Butterworth��ͨ�˲���
% fc=500;%����Ƶ��
% wn=2*fc/fs;%��һ��Ƶ��0-1
% [c,a]=butter(5,wn,'low'); %�˲����������߽�Ƶ�ʣ�ģʽ
% bb=filter(c,a,b(1:30000,1));
% fxx=fft(bb,N);%Ƶ�׷���
% fxx=abs(fxx(1:round(N/2-1)));
% subplot(1,2,2);plot((1:round(N/2-1))*fs/N,fxx);
% grid on;title('�˲���Ƶ��ͼ');xlabel('f/Hz');ylabel('���');
% % 
f0=50;%Ҫ�˵���Ƶ�ʣ���λHz
Ts=1/fs;
apha=-2*cos(2*pi*f0*Ts);
beta=0.99;
d=[1 apha 1];
a=[1 apha*beta beta^2];
bbb=dlsim(d,a,b(1:30000,1));%�ݲ����˲�����
fxxx=fft(bbb,N);%Ƶ�׷���
fxxx=abs(fxxx(1:round(N/2-1)));
subplot(1,2,2);plot((1:round(N/2-1))*fs/N,fxxx);
grid on;title('50Hz�ݲ���Ƶ��ͼ');xlabel('f/Hz');ylabel('���');
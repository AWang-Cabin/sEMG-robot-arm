

%����ȫ�ֱ���
global num X A center  label Nn x  a s1 s2 s3 s4 s5

% Make Automation.BDaq assembly visible to MATLAB.
BDaq = NET.addAssembly('Automation.BDaq4');
%���е�ֽ�������
a = arduino('COM7', 'Uno', 'Libraries', 'Servo');
s1 = servo(a, 'D12', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s2 = servo(a, 'D8', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s3 = servo(a, 'D9', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s4 = servo(a, 'D10', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
s5 = servo(a, 'D11', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6);
% Configure the following three parameters before running the demo.
% The default device of project is demo device, users can choose other 
% devices according to their needs. 
%���òɼ�ͨ��
deviceDescription = 'PCI-1716,BID#0'; 
startChannel = int32(0);
channelCount = int32(3);

%����ѵ���õ�ģ��
str = {'A.txt','center.txt'};
A = load(str{1});   %ͶӰ����
center = load(str{2}); %������������
label = 5*ones(100000,1);


num=1;
X = zeros(100000,3);

% Step 1: Create a 'InstantAiCtrl' for Instant AI function.
instantAiCtrl = Automation.BDaq.InstantAiCtrl();
instantAiCtrl.SelectedDevice = Automation.BDaq.DeviceInformation(...
        deviceDescription);
data = NET.createArray('System.Double', channelCount);
t = timer('TimerFcn', {@TimerCallback, instantAiCtrl, startChannel, ...
    channelCount, data}, 'period', 0.05, 'executionmode', 'fixedrate', ...
    'StartDelay', 1);
start(t);

%ֹͣ��ʱ
input('InstantAI is in progress...Press Enter key to quit!');
stop(t);
% Step 4: Close device and release any allocated resource.
instantAiCtrl.Dispose();

clear a s1 s2 s3 s4 s5


function result = BioFailed(errorCode)

result =  errorCode < Automation.BDaq.ErrorCode.Success && ...
    errorCode >= Automation.BDaq.ErrorCode.ErrorHandleNotValid;

end

function TimerCallback(obj, event, instantAiCtrl, startChannel, ...
    channelCount, data)

errorCode = instantAiCtrl.Read(startChannel, channelCount, data); 
if BioFailed(errorCode)
    throw Exception();
end
fprintf('\n');
global X num Nn A center label x a s1 s2 s3 s4 s5
for j=0:(channelCount - 1)
    X(num,1)=data.Get(0);
    X(num,2)=data.Get(1);
    X(num,3)=data.Get(2);
    fprintf('channel %d : %10f ', j, data.Get(j));
end
Nn=floor((num-128)/32);
num=num+1;

%..........................................................................��⼡���ź�

%X = A;  %Ҫ���Ե������ļ�,��У��ͨ�����
% -0.1077   -0.1498   -0.0991
% mean(X,1) % ���������ľ�ֵ= -0.0993   -0.1502   -0.1083;

XDIM = 128;       %ÿ��ͨ���Ĵ��ڿ��
TDIM = 128*3;     %һ��3��ͨ��
delt_window = 32; %�������ڿ��=32

%N = size(X,1);  %����һ���ж�����
%Nn = floor((N-XDIM)/delt_window); %�����ж��ٸ��������ڿ��
 
%���������������
if Nn>0
       i=Nn;
       t = delt_window*(i-1)+1;  %��i��������ָ��
       x = X(t: t +XDIM-1, 1:3); %X�ռ�:EMG�ź�
    
       x(:,1) = x(:,1)+1.5 ; % ȥ��ƫ��
       x(:,2) = x(:,2)+1.5 ;
       x(:,3) = x(:,3)+1.5 ;
       x = abs(x);     %ȡ����ֵ
       x(:,1) = min(x(:,1),0.6); %�޷�
       x(:,2) = min(x(:,2),0.6);
       x(:,3) = min(x(:,3),0.6);
    
       x = reshape(x, 1,3*XDIM);    
       p = x*A;   %��ǰ����ͶӰ�������
       temp = center -repmat(p,5,1);
       dist = sum(temp.*temp,2);    
       [~, pidx] = min(dist,[],1);  %��С�����Ӧ�����
    
       %�������������ȵ������Ϊ��ͬ���  
       t =  delt_window*(i-1) + XDIM -1;

       label(t: t+delt_window) = pidx;
%............................................................���ƻ�е��
      movation = pidx;
      if movation == 3   %��ȭ
        writePosition(s1, 1);
        writePosition(s2, 0);
        writePosition(s3, 0);
        writePosition(s4, 0);
        writePosition(s5, 1);
      elseif movation == 4 %���� ��
        writePosition(s1, 0);
        writePosition(s2, 1);
        writePosition(s3, 1);
        writePosition(s4, 1);
        writePosition(s5, 0);
     elseif movation == 1  %��ʳָ
        writePosition(s1, 0.6);
        writePosition(s2, 0.3);
        writePosition(s3, 1);
        writePosition(s4, 1);
        writePosition(s5, 0);
     elseif movation == 2  %����ָ
        writePosition(s1, 0.6);
        writePosition(s2, 1);
        writePosition(s3, 0.3);
        writePosition(s4, 1);
        writePosition(s5, 0);    
     elseif movation == 5 %��Ϣ
        writePosition(s1, 0.5);
        writePosition(s2, 0.5);
        writePosition(s3, 0.5);
        writePosition(s4, 0.5);
        writePosition(s5, 0.5);   
     
      end
  
end

end
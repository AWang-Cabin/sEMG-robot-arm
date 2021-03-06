function filted = p_butter(data)
% butterworth��ͨ�˲�
% 1-t, 2-ch1, 3-ch2, 4-ch3, 5-label;

fs=100;%����Ƶ�ʣ���λHz
fc=10;%����Ƶ��
wn=2*fc/fs;%��һ��Ƶ��0-1
[b,a]=butter(5,wn,'high'); %�˲����������߽�Ƶ�ʣ�ģʽ

if size(data,2)==5
filted(:,1)=data(:,1);
filted(:,2)=filter(b,a,data(:,2));%�ݲ����˲�����
filted(:,3)=filter(b,a,data(:,3));
filted(:,4)=filter(b,a,data(:,4));
filted(:,5)=data(:,5);
    
elseif size(data,2)==4
filted(:,1)=data(:,1);
filted(:,2)=filter(b,a,data(:,2));%�ݲ����˲�����
filted(:,3)=filter(b,a,data(:,3));
filted(:,4)=filter(b,a,data(:,4));

else
    disp("Function Inputdata Error.")
end

end


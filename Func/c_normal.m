%% ���й�һ�� normalization
% ��������Ϊ��λ��һ����ת��Ϊlibsvm����,OriginalData���һ�б������ǩ,veciΪ������
function [normal,rule]=c_normal(OriginalData,ymin,ymax,veci)

normalrule(:,1)=(1:veci);% ��һ��������������

for i=1:veci
data = OriginalData(:,i); % չ�������i�У�Ȼ��ת��Ϊһ�С�
xmax=max(data);
xmin=min(data);
normaldata(:,i)=(ymax-ymin)*(data-xmin)/(xmax-xmin)+ymin;% �����С��һ
normalrule(i,2:3)=[xmin,xmax];

end
normal=[normaldata,OriginalData(:,(veci+1))];
rule=[veci,ymin,ymax;
      normalrule];

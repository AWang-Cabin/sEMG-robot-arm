%% ���й�һ�� normalization
% ��������Ϊ��λ��һ����ת��Ϊlibsvm����,OriginalData���һ�б������ǩ,veciΪ������
function normal=c_normal_rule(OriginalData,normalrule)

veci=normalrule(1,1);
ymin=normalrule(1,2);
ymax=normalrule(1,3);

for i=1:veci
data = OriginalData(1,i); % data-��i������

xmin=normalrule(i+1,2);
xmax=normalrule(i+1,3);
%���������������Χ
if data>=xmax
    data=xmax;
elseif data<=xmin
    data=xmin;
end
%�������һ��
normaldata(1,i)=(ymax-ymin)*(data-xmin)/(xmax-xmin)+ymin;
end
normal=[normaldata,OriginalData(1,(veci+1))];% ����ǩ���


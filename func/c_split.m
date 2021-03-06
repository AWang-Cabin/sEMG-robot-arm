function [x_train, y_train,  x_test, y_test] = c_split(x, y, ratio)
%split_dataset �ָ�ѵ�����Ͳ��Լ�
%  ����x�����ݾ��� y�Ƕ�Ӧ���ǩ ratio��ѵ�����ı���
%  ����ѵ����x_train�Ͷ�Ӧ�����ǩy_train ���Լ�x_test�Ͷ�Ӧ�����ǩy_test

m = size(x, 1);
y_labels = unique(y); % ȥ�أ�kӦ�õ���length(y_labels) 
d = (1:m)';%�����������ݵ���ž���1-m
x_train(2500,27)=0;%Ԥ�����ڴ�
y_train(2500,1)=0;

for i = 1:4
    all_i = find(y == y_labels(i));% ��I�������������
    size_all_i = length(all_i);
    rp = randperm(size_all_i); % �������1-k����������
    rp_ratio = rp(1:floor(size_all_i * ratio));% ���ɣ�k*ratio����1-k�ڵ�����

   %����ѵ����
   if i==1
       x_train = x(all_i(rp_ratio),:);
       y_train = y(all_i(rp_ratio),:);
   else
       x_train = [x_train; x(all_i(rp_ratio),:)];
       y_train = [y_train; y(all_i(rp_ratio),:)];
   end
    d = setdiff(d, all_i(rp_ratio)); % ȡ���ݼ�������Ԫ��
end
% ���ɲ��Լ�
x_test = x(d, :);
y_test = y(d, :);

end



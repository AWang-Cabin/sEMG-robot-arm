function out=p_outlier(delete)
% ȥҰֵ

for j=2:4
    dj=delete(:,j);% ��ͨ�����ȥҰֵ
   for i=21:size(dj)
       m=max(abs(dj(i-20:i-1)));
       me=mean(abs(dj(i-20:i)));
       if abs(dj(i))>3*m % ����ֵ��������ֵ����Ϊ2����ֵ
          if dj(i)<0
              dj(i)=-2*me;
          else
              dj(i)=2*me;
          end
       end
   end
   delete(:,j)=dj;
end
out=delete;

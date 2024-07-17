function [T,f,F] = Heart_rate(filename)
% ��ȡ�����ļ�
[t,data] = textread(filename,'%f%f','headerlines',1);
figure(1);plot(t,data);title('δ����������ĵ��ź�');

% ������ݣ�������tΪ0�Ŀ�ֵ����ȥ����Щ��
n = length(data);
while(t(n) == 0)
    n = n -1;
end
data = data(1:n);
t = t(1:n);

% ���Ҽ�ֵ��extre�д�ż�ֵ�뼫ֵ�� ��ʽ��extra����ֵ����ֵ�㣩
extre = [];
for i = 1 : n-2
    % ��ֵ���жϱ�׼
    if (data(i+1) >= data(i) && data(i+1) >= data(i+2))||(data(i+1) <= data(i) && data(i+1) <= data(i+2))
         extre = [extre;data(i),i];
    end
end

% �����ݼ�ֵ��һ�н�����������
extre = sortrows(extre,1);
len = length(extre);
% ����������׺��ҵ���ȡ��ֵ�ķ�����thr=(Max-Min)*0.3
% Max�����8������ֵ��ƽ��ֵ��Min����С100����Сֵ��ƽ��ֵ
Max = 0;Min = 0;
for i = (len-7) : len
    Max = Max + extre(i,1);
end
Max = Max / 8;
for i = 1:100
    Min = Min + extre(i,1);
end
Min = Min / 100;
thr = (Max - Min) * 0.3;

% ����ɸѡ��ɸѡ��������ֵ�ļ�ֵ��
value = [];
for i = 1 : len
    if extre(i,1) > thr
        value = [value;extre(i,2)];
    end
end

% ����ɸѡ������������ֵ֮�䣬ʱ���Ӧ�ô���0.4s��С��0.4s�Ķ�ɸ��
 i = 2;
 rate = 0.00125; % �ɲ���Ƶ������ 800hz
 value = sort(value); % ��������
 k = length(value);
 while i <= k
     if abs(value(i) - value(i-1)) * rate < 0.4
         if data(value(i)) > data(value(i-1))
             value(i-1) = [];
         else
             value(i) = [];
         end
         k = length(value);
         i = i - 1;
     end
     i = i + 1;
 end
 
 % ��ͼ������ԭ�źźͱ��������(R��)
 figure(2);plot(t,data,t(value),data(value),'o');title('�����������ĵ��ź�')
 % �������ں�����
 T = ((value(length(value)) - value(1)) / length(value)) * rate;
 F = int16(60 / T);
 f = 1 / T;
end


        


        
    
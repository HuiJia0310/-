function [T,f,F] = Heart_rate(filename)
% 读取数据文件
[t,data] = textread(filename,'%f%f','headerlines',1);
figure(1);plot(t,data);title('未标记特征的心电信号');

% 检查数据，若出现t为0的空值，则去掉这些点
n = length(data);
while(t(n) == 0)
    n = n -1;
end
data = data(1:n);
t = t(1:n);

% 查找极值，extre中存放极值与极值点 格式：extra（极值，极值点）
extre = [];
for i = 1 : n-2
    % 极值的判断标准
    if (data(i+1) >= data(i) && data(i+1) >= data(i+2))||(data(i+1) <= data(i) && data(i+1) <= data(i+2))
         extre = [extre;data(i),i];
    end
end

% 按数据极值这一列进行升序排序
extre = sortrows(extre,1);
len = length(extre);
% 查找相关文献后，找到了取阈值的方法，thr=(Max-Min)*0.3
% Max是最大8个极大值的平均值，Min是最小100个极小值的平均值
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

% 初次筛选，筛选出大于阈值的极值点
value = [];
for i = 1 : len
    if extre(i,1) > thr
        value = [value;extre(i,2)];
    end
end

% 二次筛选，相邻两个极值之间，时间差应该大于0.4s，小于0.4s的都筛掉
 i = 2;
 rate = 0.00125; % 由采样频率所得 800hz
 value = sort(value); % 升序排序
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
 
 % 作图，画出原信号和标记特征点(R波)
 figure(2);plot(t,data,t(value),data(value),'o');title('标记特征后的心电信号')
 % 计算周期和心率
 T = ((value(length(value)) - value(1)) / length(value)) * rate;
 F = int16(60 / T);
 f = 1 / T;
end


        


        
    
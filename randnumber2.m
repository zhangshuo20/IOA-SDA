function [n1, n2] = randnumber2(old)
% 在old矩阵中随机选择两个行业n1,n2 （n1<n2）
% old矩阵为投入产出表的第一和第二象限的组合，即中间需求和最终需求

global k
% n,m,k是投入产出矩阵的行业数，最终需求数和最终投入数
[a,b]=size(old);
n=a-k-1; %行业数量，由于old在被不断地合并行业，每一次合并都会减少行业数量，而k不会变。新的行业需计算，用nn表示

num=randi([1 n],1,2);%在1:n之间随机选择两个整数，作为要合并的行业，num为1行2列的矩阵，代表两个整数随机数
while num(1)==num(2)
    num=randi([1 n],1,2); %如果两个随机的整数相等，那么就重新选择这两个随机整数，直到二者不相等
end
n1=min(num); %num中较小的赋值给n1
n2=max(num); %num中较大的赋值给n2

end


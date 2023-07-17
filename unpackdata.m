function [Z,V,F,EP,pop] = unpackdata(data)
% unpackdata函数的功能是对数据解包
% data的结构为：data=[Z,F;V,zeros(k,m);EP,[zeros(1,m-2),pop,0]]
% Z,V,F分别为投入产出表的中间流量矩阵、最终投入矩阵、最终需求矩阵；EP为分行业的环境压力，pop为人口数
% n,m,k分别为最初的投入产出表的行业数量，最终需求数量，最终投入数量；随着投入产出的合并，n减小，m和k保持不变

global k
% n,m,k是投入产出矩阵的行业数，最终需求数和最终投入数
[a,b]=size(data);
n=a-k-1; %行业数量，由于data在被不断地合并行业，每一次合并都会减少行业数量，而k不会变。新的行业需计算，用nn表示
m=b-n; %最终需求数量

Z=data(1:n,1:n); %中间需求矩阵A(n*n)
V=data(n+1:n+k,1:n); %最终投入矩阵V(k*n)
EP=data(n+k+1,1:n);  %环境压力矩阵EP(1*n)
F=data(1:n,n+1:n+m); %最终需求矩阵F(n*m)
OI=data(n+1:n+k+1,n+1:n+m); %其他信息矩阵OI((k+1)*m),暂时无用，可删掉，但未来可扩展
pop=data(n+k+1,n+m); %人口数量pop(1*1)，标量（数据在data的最后一行，最后一列）

end


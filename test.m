clear
load zhejiang_data_IO_EC.mat
%% 对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
old=zhejiang2010;
k=0
% n,m,k是投入产出矩阵的行业数，最终需求数和最终投入数
[a,b]=size(old);
n=a-k-1; %行业数量n，由于data在被不断地合并行业，每一次合并都会减少行业数量，而k不会变。新的行业需计算，用nn表示
m=b-n; %最终需求数量m,m>=3（最后两列分别为流出EX和流入IM）

Z=old(1:n,1:n); %中间需求矩阵A(n*n)
if k==0
    V=[];
else
    V=old(n+1:n+k,1:n); %最终投入矩阵V(k*n)
end
EP=old(n+k+1,1:n);  %环境压力矩阵EP(1*n)
F=old(1:n,n+1:n+m); %最终需求矩阵F(n*m)
pop=old(n+k+1,n+m-1); %人口数量pop(1*1)，标量（数据在data的最后一行，倒数第二列）

EX=F(:,m-1); %流出数据，F的倒数第2列
IM=F(:,m); %流入数据，F的最后一列

X=(sum(Z'))'+(sum(F'))'-2*IM; % 计算分行业的总产出 X (n*1)
Z1=diag(1-IM./(X+IM))*Z;  %摊分后的中间流量矩阵Z(n*n)
Z=Z1;
F(:,1:m-1)=diag(1-IM./(X+IM))*F(:,1:m-1);  %将流出摊分扣减在所有的最终需求中
F(:,m)=[]; %删掉原来F的最后一行（流入IM），最终需求减少一个
%将各变量拼凑，恢复为输入形式的数据new (最终需求的个数-1)，Z和F发生变化
if k==0
    new=[Z,F;EP,[zeros(1,m-2),pop]]; 
else
    new=[Z,F;V,zeros(k,m-1);EP,[zeros(1,m-2),pop]]; 
end




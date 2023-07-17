function new = merge(old,n1,n2)
% merge函数的功能是对矩阵old的n1和n2两个行业进行合并
% 已进行预先设定，n1<n2
% 合并的规则是对应的行和列直接相加，构成新的行和列
% 合并后生成的新矩阵为new，new比old少1行和1列

global k
% n,m,k是投入产出矩阵的行业数，最终需求数和最终投入数
[a,b]=size(old);
n=a-k-1; %行业数量，由于old在被不断地合并行业，每一次合并都会减少行业数量，而k不会变。新的行业需计算，用nn表示

if n2>n
    disp('error,please input new numbers of n1 and n2')
    new=0;
    return %如果需要合并的最大行业编号n2大于old矩阵的行业数量n，那么提示出错，跳出函数
else
    old(n1,:)=old(n1,:)+old(n2,:); %将第n2行合并到n1行，合并结果是直接相加
    old(:,n1)=old(:,n1)+old(:,n2); %将第n2列合并到n1列，合并结果是直接相加
    old(n2,:)=[];%删除n2行
    old(:,n2)=[];%删除n2列
    new=old;%将合并后的矩阵赋值old给new
end

end


function checkdata(data,n,m,k)
% checkdata函数的功能是检查输入的数据是否正确
% n,m,k分别为投入产出表的行业数量(n>=2)，最终需求数量(m>=3，矩阵的最后两列分别为流出EX和流入IM)，最终投入数量(k>=2)
% data=[A,F;V,zeros(k,m);EP,[zeros(1,m-2),pop,0]]
% 如果正确则输出n,m,k；如果不正确则提示出错

if n<2||m<3||k<2 %判断输入的投入产出表行业数量n、最终需求数量m和最终投入数量k是否正确
    disp('wrong input for n (n>=2), m (m>=3) and k (k>=2)')
    return
end


[a,b]=size(data);

if a==(n+k+1) && b==(n+m) %检验矩阵的行列数量是否输入正确
    disp('size of data is correct')
    positive=data(:,1:n);%矩阵data的部分元素构成的新矩阵（A;V;EP）
    
    if all(positive(:)>-1e-6) %检验新矩阵是否有小于0（以-10^(-6)来代替）的元素，若有，提示出错，需要修改
        disp('no nagetive number in A, V and EP, correct!')

%% 检查投入产出表的行和列的平衡关系（各个行业的投入与产出是否相等）
%  由于结构分解需要对实际的投入产出表进行可比价格转换，这一转换使得行列平衡很难满足，所以这一检测暂时不做
%         A=data(1:n,1:n); %中间需求矩阵A(n*n)
%         V=data(n+1:n+k,1:n); %最终投入矩阵V(k*n)
%         EP=data(n+k+1,1:n);  %环境压力矩阵EP(1*n)
%         F=data(1:n,n+1:n+m); %最终需求矩阵F(n*m)
%         OI=data(n+1:n+k+1,n+1:n+m); %其他信息矩阵OI((k+1)*m),暂时无用，可删掉，但未来可扩展
%         pop=data(n+k+1,n+m); %人口数量pop(1*1)，标量
        
%         total_input=sum(A)+sum(V); %总投入向量（1*n）
%         total_output=sum(A')+sum(F');%总产出向量（1*n）
%         delta=total_input-total_output; %总投入与总产出向量之差
%                  
%         if any(abs(delta)<1e+2) %如果总投入和总产出的差值等于0（绝对值小于100）
%             disp('balanced data, correct')
%         else
%             disp('input and output are not balanced, please input the correct data')
%             return  
%         end
      
    else
        disp('nagetive number exist for A, V and EP, please input the correct data!')
        return
    end
    
else
    disp('wrong size! please input the correct data!')
    return
end

end


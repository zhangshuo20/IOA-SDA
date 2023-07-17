function checkdata(data,n,m,k)
% checkdata�����Ĺ����Ǽ������������Ƿ���ȷ
% n,m,k�ֱ�ΪͶ����������ҵ����(n>=2)��������������(m>=3�������������зֱ�Ϊ����EX������IM)������Ͷ������(k>=2)
% data=[A,F;V,zeros(k,m);EP,[zeros(1,m-2),pop,0]]
% �����ȷ�����n,m,k���������ȷ����ʾ����

if n<2||m<3||k<2 %�ж������Ͷ���������ҵ����n��������������m������Ͷ������k�Ƿ���ȷ
    disp('wrong input for n (n>=2), m (m>=3) and k (k>=2)')
    return
end


[a,b]=size(data);

if a==(n+k+1) && b==(n+m) %�����������������Ƿ�������ȷ
    disp('size of data is correct')
    positive=data(:,1:n);%����data�Ĳ���Ԫ�ع��ɵ��¾���A;V;EP��
    
    if all(positive(:)>-1e-6) %�����¾����Ƿ���С��0����-10^(-6)�����棩��Ԫ�أ����У���ʾ������Ҫ�޸�
        disp('no nagetive number in A, V and EP, correct!')

%% ���Ͷ���������к��е�ƽ���ϵ��������ҵ��Ͷ��������Ƿ���ȣ�
%  ���ڽṹ�ֽ���Ҫ��ʵ�ʵ�Ͷ���������пɱȼ۸�ת������һת��ʹ������ƽ��������㣬������һ�����ʱ����
%         A=data(1:n,1:n); %�м��������A(n*n)
%         V=data(n+1:n+k,1:n); %����Ͷ�����V(k*n)
%         EP=data(n+k+1,1:n);  %����ѹ������EP(1*n)
%         F=data(1:n,n+1:n+m); %�����������F(n*m)
%         OI=data(n+1:n+k+1,n+1:n+m); %������Ϣ����OI((k+1)*m),��ʱ���ã���ɾ������δ������չ
%         pop=data(n+k+1,n+m); %�˿�����pop(1*1)������
        
%         total_input=sum(A)+sum(V); %��Ͷ��������1*n��
%         total_output=sum(A')+sum(F');%�ܲ���������1*n��
%         delta=total_input-total_output; %��Ͷ�����ܲ�������֮��
%                  
%         if any(abs(delta)<1e+2) %�����Ͷ����ܲ����Ĳ�ֵ����0������ֵС��100��
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


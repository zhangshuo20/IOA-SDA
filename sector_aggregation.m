clear
global n m k
n=30;%行业数,n>2
m=4;%最终需求数量（m>3，最终需求矩阵的最后两列分别是流出EX和流入IM）
k=3;%最终投入数量,实际上只有k用作了全局变量

%% 读取或输入数据，并对数据进行解包
MIOT_1=abs(rand(n+k+1,n+m)*10); %生成随机矩阵 MIOT，表示投入产出表n*(n+m)
MIOT_0=abs(rand(n+k+1,n+m)*10); %生成随机矩阵 MIOT，表示投入产出表n*(n+m)

%% 检查数据是否正确
%调用checkdata函数，校验数据是否正确
checkdata(MIOT_1,n,m,k); 
checkdata(MIOT_0,n,m,k);

%% 对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
MIOT_1=data_process_im(MIOT_1,2); %采用第2种方式处理投入产出表中的IM，将2改为1或3为第1或3种方式处理IM
MIOT_0=data_process_im(MIOT_0,2); 

%% 构造元胞数组CMIOT
CMIOT_1{n-(n-1)}=MIOT_1; 
CMIOT_0{n-(n-1)}=MIOT_0; 
%定义元胞数组CMIOT，其第1个元素是矩阵MIOT，对应有n个行业；
%元胞数组CMIOT的第2个元素是矩阵MIOT随机合并2个行业后的矩阵，对应有n-1个行业；
%元胞数组CMIOT的第i个元素是矩阵MIOT随机合并i个行业后的矩阵，对应有n-(i-1)个行业；
%元胞数组CMIOT的第n-1个元素是矩阵MIOT随机合并n-1个行业后的矩阵，对应有n-(n-1-1)=2个行业；

NM=50; % 设置蒙特卡洛模拟的次数
for j=1:NM

    for i=2:n-1 % 从第2个元素（合并2个行业，剩下n-1个行业）开始，到第n-1个元素（合并n-1个行业，剩下2个行业）结束

        %调用randnumber2函数，随机选择CMIOT{i-1}中需要合并的2个行业n1和n2
        [n1,n2]=randnumber2(CMIOT_1{i-1});

        %调用merge函数，对CMIOT{i-1}矩阵的n1和n2两个行业进行合并（对应的行列直接相加）
        CMIOT_1{i}=merge(CMIOT_1{i-1},n1,n2);  % CMIOT的第i个元素是对第i-1个元素进行合并得到的
        CMIOT_0{i}=merge(CMIOT_0{i-1},n1,n2); 
    end

    for i=1:n-1  % 从第1个元素（n个行业）开始，到第n-1个元素（2个行业）结束
        %调用unpackdata函数，对CMIOT{i}进行数据解包
        [Z1,V1,F1,EP1,pop1]=unpackdata(CMIOT_1{i}) ;
        [Z0,V0,F0,EP0,pop0]=unpackdata(CMIOT_0{i});

        %调用variable_calc函数，对SDA所需的6个变量进行计算。第二象限的信息，列昂惕夫模型
        [EPI1,L1,ys1,yg1,g1,pop1]=variable_calc(Z1,V1,F1,EP1,pop1);
        [EPI0,L0,ys0,yg0,g0,pop0]=variable_calc(Z0,V0,F0,EP0,pop0);

        % 调用SDA函数，对变量的变化进行结构分解，记录分解的结果。加法分解，D&L算法
        % SDA函数的输入变量a1和a2
        a1{1}=EPI1;
        a1{2}=L1;
        a1{3}=ys1;
        a1{4}=yg1;
        a1{5}=g1;
        a1{6}=pop1;

        a0{1}=EPI0;
        a0{2}=L0;
        a0{3}=ys0;
        a0{4}=yg0;
        a0{5}=g0;
        a0{6}=pop0;

        %调用SDA函数，对变量的变化进行结构分解，记录分解的结果。可选择SDA_DL或者SDA_LMDI函数
        % Ea{j,i}=SDA_DL(a0,a1); % Ea{j,i}为合并i个行业（剩下n+1-i个行业）时的结构分解结果,已测试
        % Ea{j,i}仍然为结构体变量，其每一个元素对应a1{l}-a0{l}的变化对a1-a0的影响
        % Ea{i}=SDA_DL(a0,a1) %调用SDA_DL函数进行结构分解，加法分解，D&L算法
         [Ea{j,i},tEa{j,i}]=SDA_LMDI(a0,a1); %调用SDA_LMDI函数进行结构分解，加法分解，LMDI算法;Ea为分行业的贡献,tEa为整体的贡献
        % 

        for h=1:length(a0)
            %temp(j,i,h)=Ea{j,i}{h};%第j次蒙特卡洛模拟，合并i个行业（2:n-1），第h个因素对a1-a0变化的作用，已测试,用于SDA_DL
            temp(j,i,h)=Ea{j,i}(h); %已测试,用于SDA_LMDI
        end


    end

end

temp1=0;
for i=1:n-1 
    for h=1:length(a0)
        for j=1:NM
            %temp1=temp1+Ea{j,i}{h}; %已测试,用于SDA_DL
            temp1=temp1+Ea{j,i}(h); %已测试,用于SDA_LMDI
        end
        aver(i,h)=temp1/NM; %合并i个行业，第h个因素对a1-a0变化的作用通过蒙特卡洛模拟得到的平均值
    end
end

%% 绘图
for h=1:length(a0)
    plot((1:n-1)',aver(:,h),'or',(1:n-1)',aver(:,h));
    hold on
end
hold off

%重复以上过程10000次，求平均值，作为SDA的sector aggreagtion的不确定性



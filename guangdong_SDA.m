clear
global k
% n=42;%行业数,n>2
% m=6;%最终需求数量（m>3，最终需求矩阵的最后两列分别是流出EX和流入IM）
k=0;%最终投入数量,实际上只有k用作了全局变量

%% 读取或输入数据，并对数据进行解包
load guangdong_data.mat
% guangdong_data中的变量guangdong为元胞数组，共12个元素，均为43*50（含有进口+调出列）的EEIO矩阵；
% guangdong{i},i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=1:length(guangdong)-1
    MIOT_0=guangdong{i};
    MIOT_1=guangdong{i+1};

% %% 检查数据是否正确
% %调用checkdata函数，校验数据是否正确
% checkdata(MIOT_1,n,m,k); 
% checkdata(MIOT_0,n,m,k);

%% 对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
MIOT_0=data_process_im(MIOT_0,3); 
MIOT_1=data_process_im(MIOT_1,3); %采用第3种方式处理投入产出表中的IM，将3改为1或3为第1或2种方式处理IM

 %调用unpackdata函数，对MIOT进行数据解包
 [Z1,V1,F1,EP1,pop1]=unpackdata(MIOT_1) ;
 [Z0,V0,F0,EP0,pop0]=unpackdata(MIOT_0);

 %调用variable_calc函数，对SDA所需的6个变量进行计算。第二象限的信息，列昂惕夫模型
 [EPI1,L1,ys1,yc1,pg1,pop1]=variable_calc(Z1,V1,F1,EP1,pop1);
 [EPI0,L0,ys0,yc0,pg0,pop0]=variable_calc(Z0,V0,F0,EP0,pop0);

 %调用SDA函数，对变量的变化进行结构分解，记录分解的结果。加法分解，D&L算法
 %SDA函数的输入变量a1和a2
    a1{1}=EPI1;
    a1{2}=L1;
    a1{3}=ys1;
    a1{4}=yc1;
    a1{5}=pg1;
    a1{6}=pop1;

    a0{1}=EPI0;
    a0{2}=L0;
    a0{3}=ys0;
    a0{4}=yc0;
    a0{5}=pg0;
    a0{6}=pop0;

  %调用SDA函数，对变量的变化进行结构分解，记录分解的结果。可选择SDA_DL或者SDA_LMDI函数
    temp=SDA_DL(a0,a1); % 调用SDA_DL函数进行结构分解，加法分解，DL算法；temp为结构体变量，其每一个元素对应a1{l}-a0{l}的变化对a1-a0的影响
    for j=1:length(a0)
        Ea_DL(i,j)=temp{j};
    end
    
    %调用SDA_LMDI函数进行结构分解，加法分解，LMDI算法;
   [temp_sEa{i},temp_Ea]=SDA_LMDI(a0,a1); %temp_sEa为分行业的贡献,temp_Ea为整体的贡献
   temp_sEa{i}=temp_sEa{i}';%转置下，temp_sEa的行为行业，列为各个驱动力的贡献 
   for j=1:length(a0)
        Ea_LMDI(i,j)=temp_Ea(j);
    end
    
end

%% 将基于D&L和LMDI算法的分解结果转换为Chaining analysis的结果
%基于D&L算法的分解结果的chaining analysis，Ea_DL_chaining(i,k)为第i年第k种驱动力导致的碳排放变化
%i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6分别对应环境压力强度、列昂惕夫逆矩阵、需求结构、需求构成、人均需求、人口
Ea_DL=[zeros(1,length(a0));Ea_DL];
Ea_DL_chaining(1,:)=Ea_DL(1,:);
for i=2:length(guangdong)
    Ea_DL_chaining(i,:)=sum(Ea_DL(1:i,:));    
end

%基于LMDI算法的分解结果的chaining analysis，Ea_LMDI_chaining(i,k)为第i年第k种驱动力导致的碳排放变化
%i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6分别对应环境压力强度、列昂惕夫逆矩阵、需求结构、需求构成、人均需求、人口
Ea_LMDI=[zeros(1,length(a0));Ea_LMDI];
Ea_LMDI_chaining(1,:)=Ea_LMDI(1,:);
for i=2:length(guangdong)
    Ea_LMDI_chaining(i,:)=sum(Ea_LMDI(1:i,:));    
end

%% Chaining analysis的结果绘图
year=[1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015];
year=year';

figure(1)
plot(year,Ea_DL_chaining(:,1),year,Ea_DL_chaining(:,2),year,Ea_DL_chaining(:,3),year,Ea_DL_chaining(:,4),year,Ea_DL_chaining(:,5),year,Ea_DL_chaining(:,6))
legend('dEPI','dL','dys','dyc','dpg','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('D&L decomposition agrithom')

figure(2)
plot(year,Ea_LMDI_chaining(:,1),year,Ea_LMDI_chaining(:,2),year,Ea_LMDI_chaining(:,3),year,Ea_LMDI_chaining(:,4),year,Ea_LMDI_chaining(:,5),year,Ea_LMDI_chaining(:,6))
legend('dEPI','dL','dys','dyc','dpg','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('LMDI decomposition agrithom')

%% 基于LMDI算法计算驱动力的分行业贡献，即sectoral contribution 
[mm,nn]=size(temp_sEa{1});
sEa_chaining{1}=zeros(mm,nn);
% sEa_chaining{2}=sEa_chaining{1}+temp_sEa{1};
% sEa_chaining{3}=sEa_chaining{2}+temp_sEa{2};
for i=1:length(guangdong)-1
    sEa_chaining{i+1}=sEa_chaining{i}+temp_sEa{i};
end
% 元胞数组sEa_chaining与元胞数组guangdong的长度相同，i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
% sEa_chaining{i}(j,k)表示第i个年份，第k种驱动力在第j个行业的值
% 本模型中分解得到的驱动力包括6种，即k=1,2,3,4,5,6分别对应环境压力强度、列昂惕夫逆矩阵、需求结构、需求构成、人均需求、人口
% 行业的分类根据数据确定

%% 结果存储，存储主要结果result(6类最终需求分行业的环境压力,最终需求总量的环境压力和基于生产的环境压力）

sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%建立数据年份标签，与guangdong数据对应

for i=1:length(guangdong)       
    data=[sEa_chaining{i}(:,1),sEa_chaining{i}(:,2),sEa_chaining{i}(:,3),sEa_chaining{i}(:,4),sEa_chaining{i}(:,5),sEa_chaining{i}(:,6)]; % 将数据组集到data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % 将data切割成m*n的cell矩阵
    title={'CO2 intensity','Leontief inverse','final demand structure','final demand composition','per capita final demand','population'};% 添加变量名称
    result= [title; data_cell];                         % 将变量名称和数值组集到result
    s1=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',result,sheetname{i},'L3:Q45');% 将sEa_chaining的结果写入到文件对应位置   
end

s2=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',Ea_DL,'SDA-LMDI&DL','D4:I15');% 将Ea_DL的结果写入到文件对应位置 
s3=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',Ea_DL_chaining,'SDA-LMDI&DL','N4:S15');% 将Ea_DL_chaining的结果写入到文件对应位置
s2=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',Ea_LMDI,'SDA-LMDI&DL','D20:I31');% 将Ea_LMDI的结果写入到文件对应位置
s3=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',Ea_LMDI_chaining,'SDA-LMDI&DL','N20:S31');% 将Ea_LMDI_chaining的结果写入到文件对应位置

clear
global k
% n=42;%行业数,n>2
% m=6;%最终需求数量（m>3，最终需求矩阵的最后两列分别是流出EX和流入IM）
k=1;%最终投入数量,实际上只有k用作了全局变量

%% 读取或输入数据，并对数据进行解包
load guangdong_data_SDA.mat guangdong
% guangdong_data_SDA中的变量guangdong为元胞数组，共12个元素，均为43*50（含有进口+调出列）的EEIO矩阵；
% guangdong{i},i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015

%% 原始数据处理(把初始投入加和为1行；把最终需求加和为1列)为guangdong_new
for i=1:2
    temp1{i}=[guangdong{i}(1:41,:);sum(guangdong{i}(42:46,:));guangdong{i}(47,:)];
end
for i=3:length(guangdong)
    temp1{i}=[guangdong{i}(1:41,:);sum(guangdong{i}(42:45,:));guangdong{i}(46,:)];
end

for i=1:length(guangdong)
    temp2{i}=[temp1{i}(:,1:41),(sum((temp1{i}(:,42:47))'))'];
end
guangdong_new=temp2; %处理好的数据
clear temp1 temp2

%% 开始结构分解
for i=1:length(guangdong_new)-1
    MIOT_0=guangdong_new{i};
    MIOT_1=guangdong_new{i+1};

% %% 检查数据是否正确
% %调用checkdata函数，校验数据是否正确
% checkdata(MIOT_1,n,m,k); 
% checkdata(MIOT_0,n,m,k);

% %% 对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
% MIOT_0=data_process_im(MIOT_0,3); 
% MIOT_1=data_process_im(MIOT_1,3); %采用第3种方式处理投入产出表中的IM，将3改为1或3为第1或2种方式处理IM

 %调用unpackdata函数，对MIOT进行数据解包
 [Z1,V1,F1,EP1,pop1]=unpackdata(MIOT_1) ;
 [Z0,V0,F0,EP0,pop0]=unpackdata(MIOT_0);

 %调用variable_calc_new2函数，对SDA所需的4个变量进行计算。第二象限的信息，列昂惕夫模型
 [EPI1,L1,pf1,G1,pv1,pop1]=variable_calc_new2(Z1,V1,F1,EP1,pop1);
 [EPI0,L0,pf0,G0,pv0,pop0]=variable_calc_new2(Z0,V0,F0,EP0,pop0);

    %% 调用SDA函数，对Gosh模型4个变量的变化进行结构分解，记录分解的结果。加法分解
    %Gosh模型，SDA函数的输入变量b1和b2
    b1={pop1,pv1,G1,EPI1'};
    b0={pop0,pv0,G0,EPI0'};
    
    %Gosh模型,调用SDA函数，对变量的变化进行结构分解，记录分解的结果。可选择SDA_DL或者SDA_LMDI_new_Gosh函数
    temp_Gosh=SDA_DL(b0,b1); % 调用SDA_DL函数进行结构分解，加法分解，DL算法；temp为结构体变量，其每一个元素对应b1{l}-b0{l}的变化对b1-b0的影响
    for j=1:length(b0)
        Ea_DL_Gosh(i,j)=temp_Gosh{j};
    end

    %调用SDA_LMDI函数进行结构分解，加法分解，LMDI算法;
   [temp_sEa_Gosh{i},temp_Ea_Gosh]=SDA_LMDI_new_Gosh(b0,b1); %temp_sEa为分行业的贡献,temp_Ea为整体的贡献
   for j=1:length(b0)
        Ea_LMDI_Gosh(i,j)=temp_Ea_Gosh(j);
   end
end

%% 将基于D&L和LMDI算法的分解结果转换为Chaining analysis的结果
%基于D&L算法的分解结果的chaining analysis，Ea_DL_chaining(i,k)为第i年第k种驱动力导致的碳排放变化
%i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4分别对应环境压力强度EPI、列昂惕夫逆矩阵L、需求结构F、人口pop
Ea_DL_Gosh=[zeros(1,length(b0));Ea_DL_Gosh];
Ea_DL_chaining_Gosh(1,:)=Ea_DL_Gosh(1,:);
for i=2:length(guangdong)
    Ea_DL_chaining_Gosh(i,:)=sum(Ea_DL_Gosh(1:i,:));    
end

%基于LMDI算法的分解结果的chaining analysis，Ea_LMDI_chaining(i,k)为第i年第k种驱动力导致的碳排放变化
%i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6分别对应环境压力强度、列昂惕夫逆矩阵、需求结构、需求构成、人均需求、人口
Ea_LMDI_Gosh=[zeros(1,length(b0));Ea_LMDI_Gosh];
Ea_LMDI_chaining_Gosh(1,:)=Ea_LMDI_Gosh(1,:);
for i=2:length(guangdong)
    Ea_LMDI_chaining_Gosh(i,:)=sum(Ea_LMDI_Gosh(1:i,:));    
end

%% Chaining analysis的结果绘图
year=[1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015];
year=year';

figure(1)
plot(year,Ea_DL_chaining_Gosh(:,1),year,Ea_DL_chaining_Gosh(:,2),year,Ea_DL_chaining_Gosh(:,3),year,Ea_DL_chaining_Gosh(:,4))
legend('dEPI','dL','dpv','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('D&L decomposition agrithom')

figure(2)
plot(year,Ea_LMDI_chaining_Gosh(:,1),year,Ea_LMDI_chaining_Gosh(:,2),year,Ea_LMDI_chaining_Gosh(:,3),year,Ea_LMDI_chaining_Gosh(:,4))
legend('dEPI','dL','dpv','dpop')
xlabel('year')
ylabel('changes of CO2 (Mt)')
title('LMDI decomposition agrithom')

%% 基于LMDI算法计算驱动力的分行业贡献，即sectoral contribution 
[mm,nn]=size(temp_sEa_Gosh{1});
sEa_chaining_Gosh{1}=zeros(mm,nn);
for i=1:length(guangdong)-1
    sEa_chaining_Gosh{i+1}=sEa_chaining_Gosh{i}+temp_sEa_Gosh{i};
end
% 元胞数组sEa_chaining与元胞数组guangdong的长度相同，i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
% sEa_chaining{i}(j,k)表示第i个年份，第k种驱动力在第j个行业的值
% 本模型中分解得到的驱动力包括4种，即k=1,2,3,4分别对应环境压力强度、列昂惕夫逆矩阵、需求结构、人口
% 行业的分类根据数据确定

%% 结果存储，存储主要结果result(6类最终需求分行业的环境压力,最终需求总量的环境压力和基于生产的环境压力）

sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%建立数据年份标签，与guangdong数据对应

for i=1:length(guangdong)       
    data=[sEa_chaining_Gosh{i}(:,1),sEa_chaining_Gosh{i}(:,2),sEa_chaining_Gosh{i}(:,3),sEa_chaining_Gosh{i}(:,4)]; % 将数据组集到data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % 将data切割成m*n的cell矩阵
    title={'population','primary input structure','Gosh inverse','CO2 intensity'};% 添加变量名称
    result= [title; data_cell];                         % 将变量名称和数值组集到result
    s1=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',result,sheetname{i},'W3:Z44');% 将sEa_chaining的结果写入到文件对应位置   
end

s2=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',Ea_DL_Gosh,'SDA-LMDI&DL','D38:G49');% 将Ea_DL的结果写入到文件对应位置 
s3=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',Ea_DL_chaining_Gosh,'SDA-LMDI&DL','L38:O49');% 将Ea_DL_chaining的结果写入到文件对应位置
s2=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',Ea_LMDI_Gosh,'SDA-LMDI&DL','D54:G65');% 将Ea_LMDI的结果写入到文件对应位置
s3=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',Ea_LMDI_chaining_Gosh,'SDA-LMDI&DL','L54:O65');% 将Ea_LMDI_chaining的结果写入到文件对应位置

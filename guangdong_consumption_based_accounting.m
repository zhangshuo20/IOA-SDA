clear
global k
% nn=42;%行业数,n>2
% m=7;%最终需求数量（m>3，最终需求矩阵的最后两列分别是流出EX和流入IM）
k=0;%最终投入数量,实际上只有k用作了全局变量

%% 读取或输入数据，并对数据进行解包
load guangdong_data.mat guangdong
% guangdong_data中的变量guangdong为元胞数组，共12个元素，均为43*50（含有进口+调出列）的EEIO矩阵；
% guangdong{i},i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=1:length(guangdong)
    CEEIO=guangdong{i};

    % %调用checkdata函数，校验数据是否正确
    % checkdata(CEEIO,n,m,k); 

    %对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
    CEEIO=data_process_im(CEEIO,3); %采用第3种方式处理投入产出表中的IM，将3改为1或3为第1或2种方式处理IM

    %调用unpackdata函数，对CEEIO进行数据解包
    [Z,V,F,EP,pop]=unpackdata(CEEIO); %Z为中间投入，V为最终投入，F为最终需求，EP为环境压力，pop为人口
    
    %计算投入产出模型的变量环境压力EPI和列昂惕夫逆矩阵L
    X=(sum(Z'))'+(sum(F'))';% 计算分行业的总产出 X (n*1)
    X(find(X==0))=0.1; %将总产出X中为0的行业产出用一个很小的正值0.1替代，以免EPI=EP./X计算出错
    EPI=EP./X'; %分行业环境压力计算 (1*n)
    A=Z*inv(diag(X)); %投入产出表中间流量系数计算 (n*n)
    L=eye(length(A))/(eye(length(A))-A); % Leontief逆矩阵，最终需求系数 (n*n)
    
    %计算各类最终需求的consumption-based的环境压力
    %最终需求F的第1:6列分别对应农村消费、城镇消费、政府消费、固定资产投资、存货变化、流出（出口+调出）
    
    C_rural_consumption{i}=EPI*L*diag(F(:,1));%农村消费的环境压力（分行业）
    C_urban_consumption{i}=EPI*L*diag(F(:,2));%城镇消费的环境压力（分行业）
    C_government_consumption{i}=EPI*L*diag(F(:,3));%政府消费的环境压力（分行业）
    C_fixed_investment{i}=EPI*L*diag(F(:,4));%固定资产投资的环境压力（分行业）
    C_inventory_changes{i}=EPI*L*diag(F(:,5));%存货变化的环境压力（分行业）
    C_outflow{i}=EPI*L*diag(F(:,6));%存货变化的环境压力（分行业）
    
    C_all{i}=EPI*L*diag(sum(F'));%consumption-based 环境压力：最终需求总量的环境压力（分行业）
    P{i}=EP; %production-based 环境压力
end

% 结果存储，存储主要结果result(6类最终需求分行业的环境压力,最终需求总量的环境压力和基于生产的环境压力）
sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%建立数据年份标签，与guangdong数据对应

for i=1:length(guangdong)    
    
    data=[C_rural_consumption{i}',C_urban_consumption{i}',C_government_consumption{i}',C_fixed_investment{i}',C_inventory_changes{i}',C_outflow{i}',C_all{i}',P{i}']; % 将数据组集到data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % 将data切割成m*n的cell矩阵
    title={'C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','Production-based'};              % 添加变量名称
    result= [title; data_cell];                         % 将变量名称和数值组集到result
    s1=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results.xlsx',result,sheetname{i},'C3:J45');% 将result写入到文件中
    
end



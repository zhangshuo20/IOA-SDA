%% 本程序计算生产视角的环境压力EP_P、消费视角的环境压力EP_C 、收入视角的环境压力EP_I

clear
global k
% nn=41;%行业数,n>2
% m=7;%最终需求数量（m>3，最终需求矩阵的最后两列分别是流出EX和流入IM）
k=4;%最终投入数量,实际上只有k用作了全局变量：1987和1990年,k=5;1992-2015年,k=4

%% 读取或输入数据，并对数据进行解包
load guangdong_data_SDA.mat guangdong
% guangdong_data_accounting中的变量guangdong为元胞数组，共12个元素，均为43*50（含有进口+调出列）的EEIO矩阵；
% guangdong{i},i=1-12分别对应年份为1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=3:length(guangdong)
    CEEIO=guangdong{i};

    % %调用checkdata函数，校验数据是否正确
    % checkdata(CEEIO,n,m,k); 

    %对投入产出表数据中的流入（包括了进口和调入，IM）进行处理，处理之后投入产出表的最终需求减少了1列
    %CEEIO=data_process_im(CEEIO,3); %采用第3种方式处理投入产出表中的IM，将3改为1或3为第1或2种方式处理IM

    %调用unpackdata函数，对CEEIO进行数据解包
    [Z,V,F,EP,pop]=unpackdata(CEEIO); %Z为中间投入，V为最终投入，F为最终需求，EP为环境压力，pop为人口
    
    %计算Leontief模型和Gosh模型的各种变量
    X=(sum(Z'))'+(sum(F'))';% 计算分行业的总产出 X (n*1)
    X(find(X==0))=0.1; %将总产出X中为0的行业产出用一个很小的正值0.1替代，以免EPI=EP./X计算出错
    EPI=EP./X'; %分行业环境压力计算 (1*n)
    A=Z*inv(diag(X)); %Leontief模型，投入产出表中间流量系数计算 (n*n)
    L=eye(length(A))/(eye(length(A))-A); % Leontief逆矩阵，完全需求（投入）系数 (n*n)
    B=inv(diag(X))*Z; %Gosh模型，投入产出表直接产出（分配）系数计算 (n*n)
    G=eye(length(B))/(eye(length(B))-B); % Gosh逆矩阵，完全分配系数 (n*n)
    
    
    %%计算各类三种视角下的环境压力
    % 生产视角的环境压力EP_P
    EP_P{i}=EPI*diag(X); % EP_P与EP相等，分行业的环境压力

    % 消费视角的环境压力EP_C
    [n,mm]=size(F);
    for j=1:mm % mm为最终需求的种类,mm=6
        EP_C{i,j}=EPI*L*diag(F(:,j)); %第j种最终需求（如消费）所诱导的环境压力（分行业）
    end
    %mm=6,F数据第1:6列分别对应农村消费、城镇消费、政府消费、固定资产投资、存货变化、流出（出口+调出）
    EP_tC{i}=EPI*L*diag(sum(F')); %所有最终需求所诱导的环境压力（分行业）

    % 收入视角的环境压力EP_I
    [kk,n]=size(V);
    for j=1:kk % kk为最终投入的种类,kk=5或4
        EP_I{i,j}=diag(V(j,:))*G*EPI'; %第j种最终投入（如固定资产折旧）所诱导的环境压力（分行业）
    end
    %kk=5,1987-1990年V数据的第1:5行分别为固定资产折旧、劳动者收入、福利基金、利润和税金、其他；
    %kk=4,1992-2015年V数据的第1:4行分别对应固定资产折旧、从业人员报酬、生产税净额、营业盈余
    EP_tI{i}=diag(sum(V))*G*EPI'; %所有最终需求所诱导的环境压力（分行业）
    
end

%% 结果存储，存储主要结果result(6类最终需求分行业的环境压力,最终需求总量的环境压力和基于生产的环境压力）
sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%建立数据年份标签，与guangdong数据对应

%%1987和1990年，income-based的最终投入有5个，情况特殊
% for i=1:2    
%     
%     data=[EP_P{i}',EP_C{i,1}',EP_C{i,2}',EP_C{i,3}',EP_C{i,4}',EP_C{i,5}',EP_C{i,6}',EP_tC{i}',...
%         EP_I{i,1},EP_I{i,2},EP_I{i,3},EP_I{i,4},EP_I{i,5},EP_tI{i}]; % 将数据组集到data;
%     [mm, nn]=size(data);            
%     data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % 将data切割成m*n的cell矩阵
%     title={'Production-based','C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','I_fixed assets depreciation', 'I_income of workers', 'I_welfare funds', 'I_profits and taxes','I_others','I_all'};              % 添加变量名称
%     result= [title; data_cell];                         % 将变量名称和数值组集到result
%     s1=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',result,sheetname{i},'C3:P44');% 将result写入到文件中
%     
% end

%1992-2015年，income-based的最终投入为4个，标准化输出
for i=3:length(guangdong)    
    
    data=[EP_P{i}',EP_C{i,1}',EP_C{i,2}',EP_C{i,3}',EP_C{i,4}',EP_C{i,5}',EP_C{i,6}',EP_tC{i}',...
        EP_I{i,1},EP_I{i,2},EP_I{i,3},EP_I{i,4},EP_tI{i}]; % 将数据组集到data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % 将data切割成m*n的cell矩阵
    title={'Production-based','C_rural_consumption','C_urban_consumption','C_government_consumption','C_fixed_investment','C_inventory_changes','C_outflow','C_all','I_fixed assets depreciation', 'I_remuneration for employees', 'I_net production tax', 'I_operating surplus','I_all'};              % 添加变量名称
    result= [title; data_cell];                         % 将变量名称和数值组集到result
    s1=xlswrite('C:\Users\yuyd\Desktop\广东CO2-SDA\results_new.xlsx',result,sheetname{i},'C3:O44');% 将result写入到文件中
    
end



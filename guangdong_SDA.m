clear
global k
% n=42;%��ҵ��,n>2
% m=6;%��������������m>3��������������������зֱ�������EX������IM��
k=0;%����Ͷ������,ʵ����ֻ��k������ȫ�ֱ���

%% ��ȡ���������ݣ��������ݽ��н��
load guangdong_data.mat
% guangdong_data�еı���guangdongΪԪ�����飬��12��Ԫ�أ���Ϊ43*50�����н���+�����У���EEIO����
% guangdong{i},i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
for i=1:length(guangdong)-1
    MIOT_0=guangdong{i};
    MIOT_1=guangdong{i+1};

% %% ��������Ƿ���ȷ
% %����checkdata������У�������Ƿ���ȷ
% checkdata(MIOT_1,n,m,k); 
% checkdata(MIOT_0,n,m,k);

%% ��Ͷ������������е����루�����˽��ں͵��룬IM�����д�������֮��Ͷ���������������������1��
MIOT_0=data_process_im(MIOT_0,3); 
MIOT_1=data_process_im(MIOT_1,3); %���õ�3�ַ�ʽ����Ͷ��������е�IM����3��Ϊ1��3Ϊ��1��2�ַ�ʽ����IM

 %����unpackdata��������MIOT�������ݽ��
 [Z1,V1,F1,EP1,pop1]=unpackdata(MIOT_1) ;
 [Z0,V0,F0,EP0,pop0]=unpackdata(MIOT_0);

 %����variable_calc��������SDA�����6���������м��㡣�ڶ����޵���Ϣ���а����ģ��
 [EPI1,L1,ys1,yc1,pg1,pop1]=variable_calc(Z1,V1,F1,EP1,pop1);
 [EPI0,L0,ys0,yc0,pg0,pop0]=variable_calc(Z0,V0,F0,EP0,pop0);

 %����SDA�������Ա����ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ�����ӷ��ֽ⣬D&L�㷨
 %SDA�������������a1��a2
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

  %����SDA�������Ա����ı仯���нṹ�ֽ⣬��¼�ֽ�Ľ������ѡ��SDA_DL����SDA_LMDI����
    temp=SDA_DL(a0,a1); % ����SDA_DL�������нṹ�ֽ⣬�ӷ��ֽ⣬DL�㷨��tempΪ�ṹ���������ÿһ��Ԫ�ض�Ӧa1{l}-a0{l}�ı仯��a1-a0��Ӱ��
    for j=1:length(a0)
        Ea_DL(i,j)=temp{j};
    end
    
    %����SDA_LMDI�������нṹ�ֽ⣬�ӷ��ֽ⣬LMDI�㷨;
   [temp_sEa{i},temp_Ea]=SDA_LMDI(a0,a1); %temp_sEaΪ����ҵ�Ĺ���,temp_EaΪ����Ĺ���
   temp_sEa{i}=temp_sEa{i}';%ת���£�temp_sEa����Ϊ��ҵ����Ϊ�����������Ĺ��� 
   for j=1:length(a0)
        Ea_LMDI(i,j)=temp_Ea(j);
    end
    
end

%% ������D&L��LMDI�㷨�ķֽ���ת��ΪChaining analysis�Ľ��
%����D&L�㷨�ķֽ�����chaining analysis��Ea_DL_chaining(i,k)Ϊ��i���k�����������µ�̼�ŷű仯
%i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6�ֱ��Ӧ����ѹ��ǿ�ȡ��а�������������ṹ�����󹹳ɡ��˾������˿�
Ea_DL=[zeros(1,length(a0));Ea_DL];
Ea_DL_chaining(1,:)=Ea_DL(1,:);
for i=2:length(guangdong)
    Ea_DL_chaining(i,:)=sum(Ea_DL(1:i,:));    
end

%����LMDI�㷨�ķֽ�����chaining analysis��Ea_LMDI_chaining(i,k)Ϊ��i���k�����������µ�̼�ŷű仯
%i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015;
%k=1,2,3,4,5,6�ֱ��Ӧ����ѹ��ǿ�ȡ��а�������������ṹ�����󹹳ɡ��˾������˿�
Ea_LMDI=[zeros(1,length(a0));Ea_LMDI];
Ea_LMDI_chaining(1,:)=Ea_LMDI(1,:);
for i=2:length(guangdong)
    Ea_LMDI_chaining(i,:)=sum(Ea_LMDI(1:i,:));    
end

%% Chaining analysis�Ľ����ͼ
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

%% ����LMDI�㷨�����������ķ���ҵ���ף���sectoral contribution 
[mm,nn]=size(temp_sEa{1});
sEa_chaining{1}=zeros(mm,nn);
% sEa_chaining{2}=sEa_chaining{1}+temp_sEa{1};
% sEa_chaining{3}=sEa_chaining{2}+temp_sEa{2};
for i=1:length(guangdong)-1
    sEa_chaining{i+1}=sEa_chaining{i}+temp_sEa{i};
end
% Ԫ������sEa_chaining��Ԫ������guangdong�ĳ�����ͬ��i=1-12�ֱ��Ӧ���Ϊ1987,1990,1992,1995,1997,2000,2002,2005,2007,2010,2012,2015
% sEa_chaining{i}(j,k)��ʾ��i����ݣ���k���������ڵ�j����ҵ��ֵ
% ��ģ���зֽ�õ�������������6�֣���k=1,2,3,4,5,6�ֱ��Ӧ����ѹ��ǿ�ȡ��а�������������ṹ�����󹹳ɡ��˾������˿�
% ��ҵ�ķ����������ȷ��

%% ����洢���洢��Ҫ���result(6�������������ҵ�Ļ���ѹ��,�������������Ļ���ѹ���ͻ��������Ļ���ѹ����

sheetname={'1987','1990','1992','1995','1997','2000','2002','2005','2007','2010','2012','2015'};%����������ݱ�ǩ����guangdong���ݶ�Ӧ

for i=1:length(guangdong)       
    data=[sEa_chaining{i}(:,1),sEa_chaining{i}(:,2),sEa_chaining{i}(:,3),sEa_chaining{i}(:,4),sEa_chaining{i}(:,5),sEa_chaining{i}(:,6)]; % �������鼯��data;
    [mm, nn]=size(data);            
    data_cell=mat2cell(data, ones(mm,1), ones(nn,1));    % ��data�и��m*n��cell����
    title={'CO2 intensity','Leontief inverse','final demand structure','final demand composition','per capita final demand','population'};% ��ӱ�������
    result= [title; data_cell];                         % ���������ƺ���ֵ�鼯��result
    s1=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',result,sheetname{i},'L3:Q45');% ��sEa_chaining�Ľ��д�뵽�ļ���Ӧλ��   
end

s2=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',Ea_DL,'SDA-LMDI&DL','D4:I15');% ��Ea_DL�Ľ��д�뵽�ļ���Ӧλ�� 
s3=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',Ea_DL_chaining,'SDA-LMDI&DL','N4:S15');% ��Ea_DL_chaining�Ľ��д�뵽�ļ���Ӧλ��
s2=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',Ea_LMDI,'SDA-LMDI&DL','D20:I31');% ��Ea_LMDI�Ľ��д�뵽�ļ���Ӧλ��
s3=xlswrite('C:\Users\yuyd\Desktop\�㶫CO2-SDA\results.xlsx',Ea_LMDI_chaining,'SDA-LMDI&DL','N20:S31');% ��Ea_LMDI_chaining�Ľ��д�뵽�ļ���Ӧλ��
